require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
    @sample_crawler.parser = EventCrawler::Parser.new
  end

  it 'should correctly assign event metadata' do
    @sample_crawler.parser.should_receive(:parse) do |args|
      args.event_props.title.should == "Sample Event"
      args.event_props.description.should == "This event's description"
      args.event_props.date.should == DateTime.now.to_date

      args.venue_props.name.should == "Cafe de La Musique"
      args.venue_props.address.should == "324 Dom Pedro II Street"
    end

    @sample_crawler.crawl
  end
end
