require 'spec_helper'

describe Wombat::Property::Locators::Url do
  it 'should locate url property' do
    some_url = 'https://test.com'
    context   = double :context
    context.stub(:url).and_return some_url
    property = Wombat::DSL::Property.new('data1', :url)

    locator = Wombat::Property::Locators::Url.new(property)

    locator.locate(context).should eq({ "data1" => some_url })
  end
end
