require 'spec_helper'

describe Wombat::Properties do
  before(:each) do
    @props = Wombat::Properties.new
  end

  it 'should store event properties' do
    block_executed = false
    @props.title "/my/custom/selector", :text, { xmlns: "http://whatwg.org/xmlns" } do |x|
      block_executed = true
    end

    title = @props.get_property "title"

    title.name.should == "title"
    title.selector.should == "/my/custom/selector"
    title.format.should == :text
    title.namespaces.should == { xmlns: "http://whatwg.org/xmlns" }
    title.callback.should_not be_nil
    title.callback.call
    block_executed.should be_true
  end

  it 'should return all stored properties' do
    @props.name "something"
    @props.date DateTime.now

    @props.all_properties.size.should == 2
  end
end