require 'spec_helper'

describe Wombat::DSL::PropertyContainer do
  before(:each) do
    @metadata = Wombat::DSL::PropertyContainer.new
  end

  it 'should return an array with all the metadata properties excluding iterators' do
    @metadata["event"] = Wombat::DSL::PropertyContainer.new
    @metadata["venue"] = Wombat::DSL::PropertyContainer.new
    @metadata.another_property "/some/selector", :text
    @metadata["event"]["something"] = Wombat::DSL::PropertyContainer.new
    @metadata["event"]["something"].else "Wohooo"
    @metadata["venue"].awesome "whooea"
    it = Wombat::Iterator.new "it_selector"
    it.felipe "lima"
    @metadata.iterators << it
    
    all_propes = @metadata.all_properties
    
    all_propes.should =~ [
      @metadata["another_property"], 
      @metadata["event"]["something"]["else"], 
      @metadata["venue"]["awesome"]
    ]
  end

  it 'should be able to change properties via all_properties' do
    @metadata.another_property "/some/selector", :text
    @metadata.all_properties.first.selector = "abc"
    @metadata["another_property"].selector.should == "abc"
  end
end