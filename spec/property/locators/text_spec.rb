require 'spec_helper'

describe Wombat::Property::Locators::Text do
	it 'should locate text property with xpath selector and namespaces' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "Something cool "
		context.stub(:xpath).with("/abc", 'boom').and_return [fake_elem]
		property = Wombat::DSL::Property.new(name: 'data1', selector: 'xpath=/abc', namespaces: 'boom', format: :text)

		locator = Wombat::Property::Locators::Text.new(property, context)
	
		locator.locate.should == { "data1" => "Something cool" }
	end

	it 'should locate text property with css selector' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "My name"
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::DSL::Property.new(name: 'data1', selector: 'css=/def', format: :text)
		
		locator = Wombat::Property::Locators::Text.new(property, context)
	
		locator.locate.should == { "data1" => "My name" }
	end

	it 'should return plain symbols as strings' do
		fake_elem = double :element
		context   = double :context
		property = Wombat::DSL::Property.new(name: 'data_2', selector: :hardcoded_value, format: :text)
		
		locator = Wombat::Property::Locators::Text.new(property, context)

		locator.locate.should == { "data_2" => "hardcoded_value" }
	end

	it 'should invoke property callback' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "My name"
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::DSL::Property.new(name: 'data1', selector: 'css=/def', format: :text, callback: Proc.new { |s| s.gsub(/name/, 'ass') })
		
		locator = Wombat::Property::Locators::Text.new(property, context)
	
		locator.locate.should == { "data1" => "My ass" }
	end
end