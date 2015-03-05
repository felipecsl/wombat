require 'spec_helper'

describe Wombat::Property::Locators::Node do
	it 'should locate the node with xpath selector and namespaces' do
		fake_elem = double :element
		context   = double :context
		context.stub(:xpath).with("/abc", 'boom').and_return [fake_elem]
		property = Wombat::DSL::Property.new('data1', 'xpath=/abc', :node, 'boom')

		locator = Wombat::Property::Locators::Node.new(property)
	
		locator.locate(context).should == { "data1" => fake_elem }
	end

	it 'should locate the node with css selector' do
		fake_elem = double :element
		context   = double :context
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::DSL::Property.new('data1', 'css=/def', :node)
		
		locator = Wombat::Property::Locators::Node.new(property)
	
		locator.locate(context).should == { "data1" => fake_elem }
	end

	it 'should invoke property callback' do
		fake_elem = double :element
		context   = double :context
		fake_elem.stub property: "some property for element"
		context.stub(:css).with("/def").and_return [fake_elem]
		property = Wombat::DSL::Property.new('data1', 'css=/def', :node) { |s| s.property }
		
		locator = Wombat::Property::Locators::Node.new(property)
	
		locator.locate(context).should == { "data1" => "some property for element" }
	end
end

