require 'spec_helper'

describe Wombat::PropertyContainer do
  before(:each) do
    @metadata = Wombat::PropertyContainer.new
  end

  it 'should return an array with all the metadata properties' do
    @metadata["event"] = Wombat::PropertyContainer.new
    @metadata["venue"] = Wombat::PropertyContainer.new
    @metadata.another_property "/some/selector", :text
    @metadata["event"].something "else"
    @metadata["venue"].awesome "whooea"
    
    all_propes = @metadata.all_properties
    
    all_propes.should =~ [@metadata["another_property"], @metadata["event"]["something"], @metadata["venue"]["awesome"]]
  end

  it 'should be able to change properties via all_properties' do
    @metadata.another_property "/some/selector", :text
    @metadata.all_properties.first.selector = "abc"
    @metadata["another_property"].selector.should == "abc"
  end

  it 'should return metadata in plain hash format' do
    @metadata.title "/some/selector"
    @metadata["title"].result = "Gogobot Inc."
    @metadata["holder"] = Wombat::PropertyContainer.new
    @metadata["holder"].heading "css=.heading"
    @metadata["holder"]["heading"].result = 123456
    @metadata["holder"]["subheader"] = Wombat::PropertyContainer.new
    @metadata["holder"]["subheader"].section "/blah"
    @metadata["holder"]["subheader"]["section"].result = "Lorem Ipsum"
    @metadata.footer("another thing", :html) { |a| true }
    @metadata["footer"].result = "bla bla bla"
    
    @metadata.flatten.should == { 
      "title" => "Gogobot Inc.",
      "holder" => { 
        "heading" => 123456,
        "subheader" => {
          "section" => "Lorem Ipsum"
        }
      },
      "footer" => "bla bla bla"
    }
  end
end