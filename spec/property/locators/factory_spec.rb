require 'spec_helper'

describe Wombat::Property::Locators::Factory do
  it 'should instantiate correct locator according to property type' do
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :text)).should be_a(Wombat::Property::Locators::Text)
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :html)).should be_a(Wombat::Property::Locators::Html)
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :list)).should be_a(Wombat::Property::Locators::List)
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :follow)).should be_a(Wombat::Property::Locators::Follow)
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :iterator)).should be_a(Wombat::Property::Locators::Iterator)
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :container)).should be_a(Wombat::Property::Locators::PropertyGroup)
    Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, :url)).should be_a(Wombat::Property::Locators::Url)
  end

  it 'should raise correct exception if provided property is of unknown type' do
    lambda {
      Wombat::Property::Locators::Factory.locator_for(Wombat::DSL::Property.new(nil, nil, :weird))
    }.should raise_error(Wombat::Property::Locators::UnknownTypeException, "Unknown property format weird.")
  end
end
