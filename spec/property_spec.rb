require 'spec_helper'

describe EventCrawler::Property do
  it 'should store property data' do
    property = EventCrawler::Property.new(
      name: "title",
      selector: "/some/selector", 
      format: :html,
      callback: lambda {})
    
    property.name.should == "title"
    property.selector.should == "/some/selector"
    property.format.should == :html
    property.callback.should == lambda {}
  end
end