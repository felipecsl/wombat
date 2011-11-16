require 'spec_helper'

describe EventCrawler::Properties do
  before(:each) do
    @props = EventCrawler::Properties.new
  end

  it 'should store event properties' do
    @props.title "/my/custom/selector", :html, lambda {}

    title = @props.get_property "title"

    title.name.should == "title"
    title.selector.should == "/my/custom/selector"
    title.format.should == :html
    title.callback.should == lambda {}
  end
end