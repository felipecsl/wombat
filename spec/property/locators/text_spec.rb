require 'spec_helper'

describe Wombat::Property::Locators::Text do
	it 'should locate text property with xpath selector and namespaces' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "Something cool "
		context.stub(:xpath).with("/abc", 'boom').and_return [fake_elem]
		property = Wombat::DSL::Property.new('data1', 'xpath=/abc', :text, 'boom')

		locator = Wombat::Property::Locators::Text.new(property)
	
		locator.locate(context).should == { "data1" => "Something cool" }
	end

	it 'should locate text property with css selector' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "My name"
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::DSL::Property.new('data1', 'css=/def', :text)
		
		locator = Wombat::Property::Locators::Text.new(property)
	
		locator.locate(context).should == { "data1" => "My name" }
	end

	it 'should return plain symbols as strings' do
		fake_elem = double :element
		context   = double :context
		property = Wombat::DSL::Property.new('data_2', :hardcoded_value, :text)
		
		locator = Wombat::Property::Locators::Text.new(property)

		locator.locate(context).should == { "data_2" => "hardcoded_value" }
	end

	it 'should invoke property callback' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub inner_text: "My name"
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::DSL::Property.new('data1', 'css=/def', :text) { |s| s.gsub(/name/, 'ass') }
		
		locator = Wombat::Property::Locators::Text.new(property)
	
		locator.locate(context).should == { "data1" => "My ass" }
	end
end