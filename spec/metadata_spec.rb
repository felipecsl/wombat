require 'spec_helper'

describe EventCrawler::Metadata do
  it 'should have basic structure' do
    EventCrawler::Metadata.new[:event_props].should_not be_nil
    EventCrawler::Metadata.new[:venue_props].should_not be_nil
    EventCrawler::Metadata.new[:location_props].should_not be_nil
  end

  it 'should be able to get hash key like a method' do
    m = EventCrawler::Metadata.new
    m[:some_data] = "yeah"
    m.some_data.should == "yeah"
  end
end