require 'spec_helper'

describe Wombat::DSL::Property do
  it 'should store property data' do
    property = Wombat::DSL::Property.new("title", *["/some/selector", :html]) { false }
    
    property.wombat_property_name.should == "title"
    property.selector.should == "/some/selector"
    property.format.should == :html
    property.callback.should == lambda { false }
  end
end