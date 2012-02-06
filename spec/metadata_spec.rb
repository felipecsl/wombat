require 'spec_helper'

describe Wombat::Metadata do
  before(:each) do
    @metadata = Wombat::Metadata.new
  end

  it 'should not include non-properties in all properties list' do
    @metadata.another_property "/some/selector", :text
    @metadata.base_url "felipecsl.com"
    @metadata.list_page "/yeah"
    @metadata.all_properties.should == [@metadata['another_property']]
  end
end