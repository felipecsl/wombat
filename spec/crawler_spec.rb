require 'spec_helper'

describe Wombat::Crawler do
  before(:each) do
    @crawler = Class.new
    @crawler.send(:include, Wombat::Crawler)
    @crawler_instance = @crawler.new
  end

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

    @crawler.venue { |v| v.name "Scooba" }
    @crawler.location { |v| v.latitude -50.2323 }

    @crawler_instance.should_receive(:parse) do |arg|
      arg["event"].get_property("title").selector.should == "Fulltronic Dezembro"
      arg["event"].get_property("time").selector.to_s.should == time.to_s
      arg["venue"].get_property("name").selector.should == "Scooba"
      arg["location"].get_property("latitude").selector.should == -50.2323
    end
    
    @crawler_instance.crawl
  end

  it 'should isolate metadata between different instances' do
    another_crawler = Class.new
    another_crawler.send(:include, Wombat::Crawler)
    another_crawler_instance = another_crawler.new

    another_crawler.event { |e| e.title 'Ibiza' }
    another_crawler_instance.should_receive(:parse) { |arg| arg["event"].get_property("title").selector.should == "Ibiza" }
    another_crawler_instance.crawl

    @crawler.event { |e| e.title 'Fulltronic Dezembro' }
    @crawler_instance.should_receive(:parse) { |arg| arg["event"].get_property("title").selector.should == "Fulltronic Dezembro" }
    @crawler_instance.crawl
  end

  it 'should be able to assign arbitrary plain text metadata' do
    @crawler.some_data("/event/list", :html, "geo") {|p| true }
    
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
end