require 'spec_helper'

describe Wombat::Parser do
  before(:each) do
    @parser = Wombat::Parser.new
    @metadata = Wombat::Metadata.new
  end

  it 'should request page document with correct url' do
    @metadata.base_url "http://www.google.com"
    @metadata.event_list_page "/search"
    fake_document = double :document
    fake_parser = double :parser
    fake_document.should_receive(:parser).and_return(fake_parser)
    @parser.mechanize.should_receive(:get).with("http://www.google.com/search").and_return fake_document
    
    @parser.parse @metadata
  end

  it 'should send correct data to locate method' do
    fake_document = double :document
    fake_parser = double :parser
    fake_document.should_receive(:parser).and_return(fake_parser)
    @parser.mechanize.stub(:get).and_return fake_document
    @parser.should_receive(:locate).with(@metadata)
    @parser.parse @metadata
  end

  it 'should invoke metadata callbacks' do
    fake_document = double :document
    fake_parser = double :parser
    property = double :property
    block_called = false
    block = lambda { |p| block_called = true }
    
    property.stub(:result)
    fake_document.should_receive(:parser).and_return(fake_parser)
    property.should_receive(:callback).twice.and_return(block)
    
    @parser.mechanize.stub(:get).and_return fake_document
    @parser.should_receive(:locate).with(@metadata)
    @metadata.should_receive(:all_properties).and_return [property]

    @parser.parse @metadata

    block_called.should be_true
  end

  it 'should invoke callback with parsed data' do
    fake_document = double :document
    fake_parser = double :parser
    property = double :property
    block_called = false
    block = lambda { |p|
      block_called = true 
      p.should == "blah"
    }
    
    property.should_receive(:result).and_return("blah")
    fake_document.should_receive(:parser).and_return(fake_parser)
    property.should_receive(:callback).twice.and_return(block)
    
    @parser.mechanize.stub(:get).and_return fake_document
    @parser.should_receive(:locate).with(@metadata)
    @metadata.should_receive(:all_properties).and_return [property]

    @parser.parse @metadata

    block_called.should be_true
  end
end
