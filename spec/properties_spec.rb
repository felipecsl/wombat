require 'spec_helper'

describe EventCrawler::Properties do
  before(:each) do
    @props = EventCrawler::Properties.new
  end

  it 'should store event properties' do
    @props.title "/my/custom/selector"
    @props.title.selector.should == "/my/custom/selector"
  end
end