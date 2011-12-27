require 'spec_helper'

describe Wombat::Metadata do
  it 'should have basic structure' do
    metadata = Wombat::Metadata.new

    metadata[:event_props].class.should == Wombat::Properties
    metadata[:venue_props].class.should == Wombat::Properties
    metadata[:location_props].class.should == Wombat::Properties

    metadata.event_props.should == metadata[:event_props]
    metadata.venue_props.should == metadata[:venue_props]
    metadata.location_props.should == metadata[:location_props]
  end

  it 'should be able to get hash key like a method' do
    m = Wombat::Metadata.new
    m[:some_data] = "yeah"
    m.some_data.should == "yeah"
  end
end