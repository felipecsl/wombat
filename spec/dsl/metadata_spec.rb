require 'spec_helper'

describe Wombat::DSL::Metadata do
  before(:each) do
    @metadata = Wombat::DSL::Metadata.new
  end

  it 'should not include non-properties in all properties list' do
    @metadata.another_property "/some/selector", :text
    @metadata.base_url "felipecsl.com"
    @metadata.list_page "/yeah"
    @metadata.all_properties.should == [@metadata['another_property']]
  end

  it 'should store iterators' do
    @metadata.for_each("some_selector").kind_of?(Wombat::Iterator).should be_true
    @metadata.iterators.size.should == 1
    @metadata.iterators.first.selector.should == "some_selector"
  end
end