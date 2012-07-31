require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
  end

  it 'should correctly assign event metadata' do
    @sample_crawler.should_receive(:parse) do |args|
      args['event_group'].wombat_property_selector.should == "css=div.title-agenda"
      it = args['event_group']
      it["event"]["title"].wombat_property_selector.should == "xpath=."
      it["event"]["date"].wombat_property_selector.should == "xpath=//div[@class='scrollable-items']/div[@class='s-item active']//a"
      it["event"]["type"].wombat_property_selector.should == "xpath=.type"
      it["venue"]["name"].wombat_property_selector.should == "xpath=."

      args[:base_url].should == 'http://www.obaoba.com.br'
      args[:list_page].should == '/porto-alegre/agenda' 
    end

    @sample_crawler.crawl
  end
end
