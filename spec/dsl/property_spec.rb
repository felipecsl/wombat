require 'spec_helper'

describe Wombat::DSL::Property do
  it 'should store property data' do
    callback = lambda { false }
    property = Wombat::DSL::Property.new("title", *["/some/selector", :html], &callback)

    property.wombat_property_name.should eq "title"
    property.selector.should eq "/some/selector"
    property.format.should eq :html
    property.callback.should eq callback
  end
end
