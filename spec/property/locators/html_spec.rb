require 'spec_helper'

describe Wombat::Property::Locators::Html do
	it 'should locate html property' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_html: "Something cool "
		context.stub(:xpath).with("/abc", nil).and_return [fake_elem]
		property = Wombat::DSL::Property.new(wombat_property_name: 'data1', selector: 'xpath=/abc', format: :html)

		locator = Wombat::Property::Locators::Html.new(property, context)

		locator.locate.should == { "data1" => "Something cool" }
	end
end