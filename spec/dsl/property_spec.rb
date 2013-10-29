require 'spec_helper'

describe Wombat::DSL::Property do
  it 'should store property data' do
    callback = lambda { false }
    property = Wombat::DSL::Property.new("title", *["/some/selector", :html], &callback)
    
    property.wombat_property_name.should == "title"
    property.selector.should == "/some/selector"
    property.format.should == :html
    property.callback.should == callback
  end
end
