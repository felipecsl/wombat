require 'spec_helper'

describe Wombat::PropertyLocator do
  before(:each) do
    @locator = Class.new
    @locator.send(:include, Wombat::PropertyLocator)
    @locator_instance = @locator.new
    @metadata = Wombat::Metadata.new
  end

  it 'should locate metadata properties' do
    context = double :context
    context.stub(:xpath).with("/abc", nil).and_return(["Something cool"])
    context.stub(:css).with("/ghi").and_return(["Another stuff"])

    @metadata.event_props.data1 "xpath=/abc"
    @metadata.venue_props.data2 :farms
    @metadata.location_props.data3 "css=/ghi"

    @locator_instance.stub(:context).and_return context
    
    @locator_instance.locate @metadata

    @metadata.event_props.get_property("data1").result.should == "Something cool"
    @metadata.venue_props.get_property("data2").result.should == "farms"
    @metadata.location_props.get_property("data3").result.should == "Another stuff"
  end

  it 'should support properties with html format' do
    context = double :context
    html_info = double :html_info

    html_info.should_receive(:inner_html).and_return("some another info ")
    context.should_receive(:xpath).with("/anotherData", nil).and_return([html_info])

    @locator_instance.stub(:context).and_return context

    @metadata.event_props.another_info "xpath=/anotherData", :html

    @locator_instance.locate @metadata

    @metadata.event_props.get_property("another_info").result.should == "some another info"
  end

  it 'should trim property contents and use namespaces if present' do
    context = double :context
    context.should_receive(:xpath).with("/event/some/description", "blah").and_return(["  awesome event    "])

    @locator_instance.stub(:context).and_return context
    @metadata.event_props.description "xpath=/event/some/description", :text, "blah"

    @locator_instance.locate @metadata

    @metadata.event_props.get_property("description").result.should == "awesome event"
  end
end
