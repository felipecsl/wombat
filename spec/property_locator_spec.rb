require 'spec_helper'

describe EventCrawler::PropertyLocator do
  before(:each) do
    @locator = Class.new
    @locator.send(:include, EventCrawler::PropertyLocator)
    @locator_instance = @locator.new
  end

  it 'should locate metadata properties' do
    context = double :context
    context.stub(:xpath).with("/abc", nil).and_return(["Something cool"])
    context.stub(:css).with("/ghi").and_return(["Another stuff"])

    metadata = EventCrawler::Metadata.new
    metadata.event_props.data1 "xpath=/abc"
    metadata.venue_props.data2 :farms
    metadata.location_props.data3 "css=/ghi"

    @locator_instance.stub(:context).and_return context
    
    @locator_instance.locate metadata

    metadata.event_props.get_property("data1").result.should == "Something cool"
    metadata.venue_props.get_property("data2").result.should == "farms"
    metadata.location_props.get_property("data3").result.should == "Another stuff"
  end
end
