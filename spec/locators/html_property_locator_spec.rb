require 'spec_helper'

describe Wombat::Locators::HtmlPropertyLocator do
	it 'should locate html property' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_html: "Something cool "
		context.stub(:xpath).with("/abc", nil).and_return [fake_elem]
		property = Wombat::Property.new(name: 'data1', selector: 'xpath=/abc', format: :html)

		locator = Wombat::Locators::HtmlPropertyLocator.new(property, context)

		locator.locate.should == "Something cool"
	end
end