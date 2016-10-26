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

      expect(event_called).to eq(true)
    end

    it 'should provide metadata to yielded block' do
      @crawler.event do
        self.class.should eq(Wombat::DSL::PropertyGroup)
      end
    end

    it 'should store assigned metadata information' do
      time = Time.now

      @crawler.event do |e|
        e.title 'Fulltronic Dezembro'
        e.time Time.now
      end

      @crawler.venue do |v|
        v.name "Scooba"
      end

      @crawler.location { |v| v.latitude -50.2323 }

      expect(@crawler_instance).to receive(:parse) do |arg|
        expect(arg["event"]["title"].selector).to eq("Fulltronic Dezembro")
        expect(arg["event"]["time"].selector.to_s).to eq(time.to_s)
        expect(arg["venue"]["name"].selector).to eq("Scooba")
        expect(arg["location"]["latitude"].selector).to eq(-50.2323)
      end

      @crawler_instance.crawl
    end

    it 'should isolate metadata between different instances' do
      another_crawler = Class.new
      another_crawler.send(:include, Wombat::Crawler)
      another_crawler_instance = another_crawler.new

      another_crawler.event { |e| e.title 'Ibiza' }
      expect(another_crawler_instance).to receive(:parse) { |arg|
        expect(arg["event"]["title"].selector).to eq("Ibiza")
      }
      another_crawler_instance.crawl

      @crawler.event { |e| e.title 'Fulltronic Dezembro' }
      expect(@crawler_instance).to receive(:parse) { |arg|
        expect(arg["event"]["title"].selector).to eq("Fulltronic Dezembro")
      }
      @crawler_instance.crawl
    end

    it 'should be able to assign arbitrary plain text metadata' do
      @crawler.some_data("/event/list", :html, "geo") { |p| true }

      expect(@crawler_instance).to receive(:parse) do |arg|
        prop = arg['some_data']
        expect(prop.wombat_property_name).to eq("some_data")
        expect(prop.selector).to eq("/event/list")
        expect(prop.format).to eq(:html)
        expect(prop.namespaces).to eq("geo")
        expect(prop.callback).to_not eq(nil)
      end

      @crawler_instance.crawl
    end

    it 'should be able to specify arbitrary block structure more than once' do
      @crawler.structure do
        data "xpath=/xyz"
      end

      @crawler.structure do
        another "css=.information"
      end

      expect(@crawler_instance).to receive(:parse) do |arg|
        expect(arg["structure"]["data"].selector).to eq("xpath=/xyz")
        expect(arg["structure"]["another"].selector).to eq("css=.information")
      end

      @crawler_instance.crawl
    end

    it 'should not explode if no block given' do
      @crawler.event
    end

    it 'should assign metadata format' do
      expect(@crawler_instance).to receive(:parse) do |arg|
        expect(arg[:document_format]).to eq(:xml)
      end
      @crawler.document_format :xml
      @crawler_instance.crawl
    end

    it 'should crawl with block' do
      @crawler.base_url "danielnc.com"
      @crawler.path "/itens"

      expect(@crawler_instance).to receive(:parse) do |arg|
        expect(arg[:base_url]).to eq("danielnc.com")
        expect(arg[:path]).to eq("/itens/1")
      end

      @crawler_instance.crawl do
        path "/itens/1"
      end

      another_instance = @crawler.new

      expect(another_instance).to receive(:parse) do |arg|
        expect(arg[:base_url]).to eq("danielnc.com")
        expect(arg[:path]).to eq("/itens")
      end

      another_instance.crawl
    end

    it 'should crawl with url and block' do
      url = 'http://danielinc.com/itens'

      opts = {cookies: :cookies}
      expect(@crawler_instance).to receive(:parse).with(anything, url, opts)
      @crawler_instance.crawl(url, opts) do
      end

      another_instance = @crawler.new
      expect(another_instance).to receive(:parse).with(anything, url, opts)

      another_instance.crawl(url, opts)
    end

    it 'should remove created method missing' do
      @crawler.base_url "danielnc.com"
      @crawler.path "/itens"

      expect(@crawler_instance).to receive(:parse) do |arg|
        expect(arg[:base_url]).to eq("danielnc.com")
        expect(arg[:path]).to eq("/itens/1")
      end

      @crawler_instance.crawl do
        path "/itens/1"
      end

      expect(lambda {
        @craler_intance.undefined_method
      }).to raise_error(NoMethodError)
    end

    it 'should remove created instance variable' do
      @crawler.base_url "danielnc.com"
      @crawler.path "/itens"

      expect(@crawler_instance).to receive(:parse) do |arg|
        expect(arg[:base_url]).to eq("danielnc.com")
        expect(arg[:path]).to eq("/itens/1")
      end

      @crawler_instance.crawl do
        path "/itens/1"
      end

      expect(@crawler_instance.instance_variables.index(:@metadata_dup)).to be_nil
    end

    context "response code" do
      it "should have correct mechanize response code" do
        VCR.use_cassette('basic_crawler_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.path '/portal'

          @crawler.search "css=.btn-search"

          @crawler_instance.crawl
          expect(@crawler_instance.response_code).to be(200)
        end

      end
      it "should have correct rest client code" do
        VCR.use_cassette('basic_crawler_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.path '/portal'

          @crawler.search "css=.btn-search"
          @crawler.document_format :xml

          @crawler_instance.crawl
          expect(@crawler_instance.response_code).to be(200)
        end
      end

      it "should have mechanize error response code" do
        VCR.use_cassette('error_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.path '/portal'

          @crawler.search "css=.btn-search"

          expect(lambda { @crawler_instance.crawl }).to raise_error(
            "404 => Net::HTTPNotFound for http://www.terra.com.br/portal/ -- unhandled response")
          expect(@crawler_instance.response_code).to be(404)
        end
      end

      it "should have rest client error response code" do
        VCR.use_cassette('error_page') do

          @crawler.base_url "http://www.terra.com.br"
          @crawler.path '/portal'

          @crawler.search "css=.btn-search"
          @crawler.document_format :xml
          expect(lambda {
            @crawler_instance.crawl
          }).to raise_error(RestClient::ResourceNotFound)
          expect(@crawler_instance.response_code).to be(404)
        end
      end
    end
  end

  describe '#scrape' do
    it 'should alias to crawl' do
      expect(@crawler_instance).to receive :parse
      @crawler_instance.scrape
    end
  end
end
