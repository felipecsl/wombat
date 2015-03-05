require 'spec_helper'

describe Wombat::Property::Locators::NodeList do
	it 'should locate a list of nodes' do
		fake_elem = double :element
		context   = double :context
		context.stub(:css).with(".selector").and_return [fake_elem] * 3
		property = Wombat::DSL::Property.new('data1', 'css=.selector', :node_list)

		locator = Wombat::Property::Locators::NodeList.new(property)

		locator.locate(context).should == { "data1" => [fake_elem] * 3 }
	end

	it 'should invoke property callback' do
		fake_elems = [ double(:element) ] * 3
		context    = double :context
		fake_elems.each{|elem| elem.stub property: "some property for element" }
		context.stub(:css).with("/def").and_return fake_elems
		properties = Wombat::DSL::Property.new('data1', 'css=/def', :node_list){|n| n.map(&:property) }

		locator = Wombat::Property::Locators::NodeList.new(properties)

		locator.locate(context).should == { "data1" => ["some property for element"] * 3 }
	end
end

