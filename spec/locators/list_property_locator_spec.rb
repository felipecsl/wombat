require 'spec_helper'

describe Wombat::Locators::ListPropertyLocator do
	it 'should locate a list of nodes' do
		context   = double :context
		context.stub(:css).with(".selector").and_return %w(1 2 3 4 5)
		property = Wombat::Property.new(name: 'data1', selector: 'css=.selector', format: :list)

		locator = Wombat::Locators::ListPropertyLocator.new(property, context)

		locator.locate.should == %w(1 2 3 4 5)
	end
end