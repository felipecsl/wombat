require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
  end

  it 'should correctly assign event metadata' do
    @sample_crawler.should_receive(:parse) do |args|
      # args["event"]["description"].selector.should == "css=#main-node-content"

      # args["venue"]["address"].selector.should == "324 Dom Pedro II Street"

      it = args.iterators.first
      it.selector.should == "css=div.title-agenda"
      it["event"]["title"].selector.should == "xpath=."
      it["event"]["date"].selector.should == "xpath=//div[@class='scrollable-items']/div[@class='s-item active']//a"
      it["event"]["type"].selector.should == "xpath=.type"
      it["venue"]["name"].selector.should == "xpath=."

      args[:base_url].should == 'http://www.obaoba.com.br'
      args[:list_page].should == '/porto-alegre/agenda' 
    end

    @sample_crawler.crawl
  end
end
