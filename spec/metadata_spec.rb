require 'spec_helper'

describe Wombat::Metadata do
  before(:each) do
    @metadata = Wombat::Metadata.new
  end

  it 'should have basic structure' do
    @metadata[:event_props].class.should == Wombat::PropertyContainer
    @metadata[:venue_props].class.should == Wombat::PropertyContainer
    @metadata[:location_props].class.should == Wombat::PropertyContainer

    @metadata[:event_props].should == @metadata[:event_props]
    @metadata[:venue_props].should == @metadata[:venue_props]
    @metadata[:location_props].should == @metadata[:location_props]
  end

  it 'should return an array with all the metadata properties' do
    @metadata.another_property "/some/selector", :text
    @metadata.event.something "else"
    @metadata.venue.awesome "whooea"
    all_propes = @metadata.all_properties
    
    all_propes.should =~ [@metadata["another_property"], @metadata.event["something"], @metadata.venue["awesome"]]
  end

  it 'should be able to change properties via all_properties' do
    @metadata.another_property "/some/selector", :text
    @metadata.all_properties.first.selector = "abc"
    @metadata["another_property"].selector.should == "abc"
  end

  it 'should not include non-properties in all properties list' do
    @metadata.another_property "/some/selector", :text
    @metadata.base_url "felipecsl.com"
    @metadata.all_properties.should == [@metadata['another_property']]
  end
end