require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
    @sample_crawler.parser = Wombat::Parser.new
  end

  it 'should correctly assign event metadata' do
    @sample_crawler.parser.should_receive(:parse) do |args|
      args.event["title"].selector.should == "Sample Event"
      args.event["description"].selector.should == "This event's description"
      args.event["date"].selector.should == DateTime.now.to_date

      args.venue["name"].selector.should == "Cafe de La Musique"
      args.venue["address"].selector.should == "324 Dom Pedro II Street"

      args[:base_url].should == 'http://www.google.com/'
      args[:event_list_page].should == 'shows.php'
    end

    @sample_crawler.crawl
  end
end
