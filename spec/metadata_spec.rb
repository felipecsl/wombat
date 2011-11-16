require 'spec_helper'

describe EventCrawler::Metadata do
  it 'should have basic structure' do
    metadata = EventCrawler::Metadata.new

    metadata[:event_props].class.should == EventCrawler::Properties
    metadata[:venue_props].class.should == EventCrawler::Properties
    metadata[:location_props].class.should == EventCrawler::Properties

    metadata.event_props.should == metadata[:event_props]
    metadata.venue_props.should == metadata[:venue_props]
    metadata.location_props.should == metadata[:location_props]
  end

  it 'should be able to get hash key like a method' do
    m = EventCrawler::Metadata.new
    m[:some_data] = "yeah"
    m.some_data.should == "yeah"
  end
end