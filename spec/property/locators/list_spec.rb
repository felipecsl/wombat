require 'spec_helper'

describe Wombat::Property::Locators::List do
	it 'should locate a list of nodes' do
		context   = double :context
		context.stub(:css).with(".selector").and_return %w(1 2 3 4 5)
		property = Wombat::DSL::Property.new('data1', 'css=.selector', :list)

		locator = Wombat::Property::Locators::List.new(property)

		locator.locate(context).should == { "data1" => %w(1 2 3 4 5) }
	end
end