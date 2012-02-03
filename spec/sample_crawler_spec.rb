require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
  end

  xit 'should correctly assign event metadata' do
    @sample_crawler.should_receive(:parse) do |args|
      args.event["title"].selector.should == "xpath=."
      args.event["description"].selector.should == "css=#main-node-content"
      args.event["date"].selector.should == DateTime.now.to_date

      args.venue["name"].selector.should == "Cafe de La Musique"
      args.venue["address"].selector.should == "324 Dom Pedro II Street"

      args[:base_url].should == 'http://www.google.com/'
      args[:list_page].should == 'shows.php'
    end

    @sample_crawler.crawl
  end
end
