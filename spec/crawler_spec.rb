require 'spec_helper'

describe Wombat::Crawler do
  before(:each) do
    @crawler = Class.new
    @crawler.send(:include, Wombat::Crawler)
    @crawler_instance = @crawler.new
  end

  describe '#crawl' do
    it 'should call the provided block' do
      event_called = false

      @crawler.event { event_called = true }

      event_called.should be_true
    end

    it 'should provide metadata to yielded block' do
      @crawler.event do |e|
        e.should_not be_nil
      end
    end

    it 'should store assigned metadata information' do
      time = Time.now

      @crawler.event do |e|
        e.title 'Fulltronic Dezembro'
        e.time Time.now
      end

      @crawler.venue do |v| 
        v.venue_name "Scooba"
      end

      @crawler.location { |v| v.latitude -50.2323 }

      @crawler_instance.should_receive(:parse) do |arg|
        arg["event"]["title"].selector.should == "Fulltronic Dezembro"
        arg["event"]["time"].selector.to_s.should == time.to_s
        arg["venue"]["venue_name"].selector.should == "Scooba"
        arg["location"]["latitude"].selector.should == -50.2323
      end

      @crawler_instance.crawl
    end

    it 'should isolate metadata between different instances' do
      another_crawler = Class.new
      another_crawler.send(:include, Wombat::Crawler)
      another_crawler_instance = another_crawler.new

      another_crawler.event { |e| e.title 'Ibiza' }
      another_crawler_instance.should_receive(:parse) { |arg| arg["event"]["title"].selector.should == "Ibiza" }
      another_crawler_instance.crawl

      @crawler.event { |e| e.title 'Fulltronic Dezembro' }
      @crawler_instance.should_receive(:parse) { |arg| arg["event"]["title"].selector.should == "Fulltronic Dezembro" }
      @crawler_instance.crawl
    end

    it 'should be able to assign arbitrary plain text metadata' do
      @crawler.some_data("/event/list", :html, "geo") { |p| true }

      @crawler_instance.should_receive(:parse) do |arg|
        prop = arg['some_data']
        prop.name.should == "some_data"
        prop.selector.should == "/event/list"
        prop.format.should == :html
        prop.namespaces.should == "geo"
        prop.callback.should_not be_nil
      end

      @crawler_instance.crawl
    end

    it 'should be able to specify arbitrary block structure more than once' do
      @crawler.structure do |s|
        s.data "xpath=/xyz"
      end

      @crawler.structure do |s|
        s.another "css=.information"
      end

      @crawler_instance.should_receive(:parse) do |arg|
        arg["structure"]["data"].selector.should == "xpath=/xyz"
        arg["structure"]["another"].selector.should == "css=.information"
      end

      @crawler_instance.crawl
    end

    it 'should not explode if no block given' do
      @crawler.event
    end

    it 'should assign metadata format' do
      @crawler_instance.should_receive(:parse) do |arg|
        arg[:document_format].should == :xml
      end
      @crawler.document_format :xml
      @crawler_instance.crawl
    end

    it 'should crawl with block' do
      @crawler.base_url "danielnc.com"
      @crawler.list_page "/itens"

      @crawler_instance.should_receive(:parse) do |arg|
        arg[:base_url].should == "danielnc.com"
        arg[:list_page].should == "/itens/1"
      end

      @crawler_instance.crawl do
        list_page "/itens/1"
      end

      another_instance = @crawler.new

      another_instance.should_receive(:parse) do |arg|
        arg[:base_url].should == "danielnc.com"
        arg[:list_page].should == "/itens"
      end

      another_instance.crawl
    end

    it 'should remove created method missing' do
      @crawler.base_url "danielnc.com"
      @crawler.list_page "/itens"

      @crawler_instance.should_receive(:parse) do |arg|
        arg[:base_url].should == "danielnc.com"
        arg[:list_page].should == "/itens/1"
      end

      @crawler_instance.crawl do
        list_page "/itens/1"
      end

      lambda { @craler_intance.undefined_method }.should raise_error(NoMethodError)
    end

    it 'should remove created instance variable' do
      @crawler.base_url "danielnc.com"
      @crawler.list_page "/itens"

      @crawler_instance.should_receive(:parse) do |arg|
        arg[:base_url].should == "danielnc.com"
        arg[:list_page].should == "/itens/1"
      end

      @crawler_instance.crawl do
        list_page "/itens/1"
      end

      @crawler_instance.instance_variables.index(:@metadata_dup).should be_nil
    end

    context "response code" do
      it "should have correct mechanize response code" do
        VCR.use_cassette('basic_crawler_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.list_page '/portal'

          @crawler.search "css=.btn-search"

          @crawler_instance.crawl
          @crawler_instance.response_code.should be(200)
        end

      end
      it "should have correct rest client code" do
        VCR.use_cassette('basic_crawler_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.list_page '/portal'

          @crawler.search "css=.btn-search"
          @crawler.document_format :xml

          @crawler_instance.crawl
          @crawler_instance.response_code.should be(200)
        end
      end

      it "should have mechanize error response code" do
        VCR.use_cassette('error_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.list_page '/portal'

          @crawler.search "css=.btn-search"

          lambda { @crawler_instance.crawl }.should raise_error("404 => Net::HTTPNotFound for http://www.terra.com.br/portal/ -- unhandled response")
          @crawler_instance.response_code.should be(404)
        end
      end

      it "should have rest client error response code" do
        VCR.use_cassette('error_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.list_page '/portal'

          @crawler.search "css=.btn-search"
          @crawler.document_format :xml
          lambda { @crawler_instance.crawl }.should raise_error(RestClient::ResourceNotFound)
          @crawler_instance.response_code.should be(404)
        end
      end
    end
  end

  describe '#scrape' do
    it 'should alias to crawl' do
      @crawler_instance.should_receive :parse
      @crawler_instance.scrape
    end
  end
end