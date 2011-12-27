require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
    @sample_crawler.parser = Wombat::Parser.new
  end

  it 'should correctly assign event metadata' do
    @sample_crawler.parser.should_receive(:parse) do |args|
      args.event_props.get_property("title").selector.should == "Sample Event"
      args.event_props.get_property("description").selector.should == "This event's description"
      args.event_props.get_property("date").selector.should == DateTime.now.to_date

      args.venue_props.get_property("name").selector.should == "Cafe de La Musique"
      args.venue_props.get_property("address").selector.should == "324 Dom Pedro II Street"
    end

    @sample_crawler.crawl
  end
end
