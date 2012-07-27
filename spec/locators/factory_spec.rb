require 'spec_helper'

describe Wombat::Locators::Factory do
	it 'should instantiate correct locator according to property type' do
		Wombat::Locators::Factory.locator_for(Wombat::Property.new(format: :text), nil).should be_a(Wombat::Locators::TextPropertyLocator)
		Wombat::Locators::Factory.locator_for(Wombat::Property.new(format: :html), nil).should be_a(Wombat::Locators::HtmlPropertyLocator)
		Wombat::Locators::Factory.locator_for(Wombat::Property.new(format: :list), nil).should be_a(Wombat::Locators::ListPropertyLocator)
		Wombat::Locators::Factory.locator_for(Wombat::Property.new(format: :follow), nil).should be_a(Wombat::Locators::FollowPropertyLocator)
		Wombat::Locators::Factory.locator_for(Wombat::Property.new(format: :iterator), nil).should be_a(Wombat::Locators::IteratorPropertyLocator)
	end

	it 'should raise correct exception if provided property is of unknown type' do
		lambda {
			Wombat::Locators::Factory.locator_for(Wombat::Property.new(format: :weird), nil)
		}.should raise_error(Wombat::PropertyLocatorTypeException, "Unknown property format weird.")
	end
end