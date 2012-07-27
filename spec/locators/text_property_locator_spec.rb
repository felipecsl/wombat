require 'spec_helper'

describe Wombat::Locators::TextPropertyLocator do
	it 'should locate text property with xpath selector and namespaces' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "Something cool "
		context.stub(:xpath).with("/abc", 'boom').and_return [fake_elem]
		property = Wombat::Property.new(name: 'data1', selector: 'xpath=/abc', namespaces: 'boom', format: :text)

		locator = Wombat::Locators::TextPropertyLocator.new(property, context)
	
		locator.locate.should == "Something cool"
	end

	it 'should locate text property with css selector' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "My name"
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::Property.new(name: 'data1', selector: 'css=/def', format: :text)
		
		locator = Wombat::Locators::TextPropertyLocator.new(property, context)
	
		locator.locate.should == "My name"
	end

	it 'shoulr return plain symbols as strings' do
		fake_elem = double :element
		context   = double :context
		property = Wombat::Property.new(name: 'data1', selector: :hardcoded_value, format: :text)
		
		locator = Wombat::Locators::TextPropertyLocator.new(property, context)

		locator.locate.should == "hardcoded_value"
	end
end