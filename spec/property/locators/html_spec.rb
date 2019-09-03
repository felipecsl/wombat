require 'spec_helper'

describe Wombat::Property::Locators::Html do
  it 'should locate html property' do
    fake_elem = double :element
    context   = double :context
    fake_elem.stub inner_html: "Something cool "
    context.stub(:xpath).with("/abc", nil).and_return [fake_elem]
    property = Wombat::DSL::Property.new('data1', 'xpath=/abc', :html)
    locator = Wombat::Property::Locators::Html.new(property)
    locator.locate(context).should eq({ "data1" => "Something cool" })
  end

  it 'should return null if the property cannot be found' do
    context   = double :context
    context.stub(:xpath).with("/abc", nil).and_return []
    property = Wombat::DSL::Property.new('data1', 'xpath=/abc', :html)
    locator = Wombat::Property::Locators::Html.new(property)
    locator.locate(context).should eq({ "data1" => nil })
  end
end
