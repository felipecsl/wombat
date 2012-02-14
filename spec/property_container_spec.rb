require 'spec_helper'

describe Wombat::PropertyContainer do
  before(:each) do
    @metadata = Wombat::PropertyContainer.new
  end

  it 'should return an array with all the metadata properties excluding iterators' do
    @metadata["event"] = Wombat::PropertyContainer.new
    @metadata["venue"] = Wombat::PropertyContainer.new
    @metadata.another_property "/some/selector", :text
    @metadata["event"]["something"] = Wombat::PropertyContainer.new
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

  it 'should return metadata in plain hash format including iterators' do
    @metadata.title "/some/selector"
    @metadata["title"].result = "Gogobot Inc."
    @metadata["holder"] = Wombat::PropertyContainer.new
    @metadata["holder"].heading "css=.heading"
    @metadata["holder"]["heading"].result = 123456
    @metadata["holder"]["subheader"] = Wombat::PropertyContainer.new
    @metadata["holder"]["subheader"].section "/blah"
    @metadata["holder"]["subheader"]["section"].result = "Lorem Ipsum"
    it = Wombat::Iterator.new "it_selector"
    it.felipe "lima"
    it["felipe"].result = ["correa", "de souza", "lima"]
    @metadata.iterators = [it]
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
      "felipe" => ["correa", "de souza", "lima"],
      "footer" => "bla bla bla"
    }
  end
end