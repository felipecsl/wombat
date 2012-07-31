require 'spec_helper'

describe Wombat::Property::Locators::Factory do
	it 'should instantiate correct locator according to property type' do
		Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :text), nil).should be_a(Wombat::Property::Locators::Text)
		Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :html), nil).should be_a(Wombat::Property::Locators::Html)
		Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :list), nil).should be_a(Wombat::Property::Locators::List)
		Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :follow), nil).should be_a(Wombat::Property::Locators::Follow)
		Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :iterator), nil).should be_a(Wombat::Property::Locators::Iterator)
		Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :container), nil).should be_a(Wombat::Property::Locators::PropertyGroup)
	end

	it 'should raise correct exception if provided property is of unknown type' do
		lambda {
			Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(format: :weird), nil)
		}.should raise_error(Wombat::Property::Locators::UnknownTypeException, "Unknown property format weird.")
	end
end