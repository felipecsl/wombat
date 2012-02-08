require 'spec_helper'

describe Wombat::Parser do
  before(:each) do
    crawler = Class.new
    crawler.send(:include, Wombat::Parser)
    @parser = crawler.new
    @metadata = Wombat::Metadata.new
  end

  it 'should request page document with correct url' do
    @metadata.base_url "http://www.google.com"
    @metadata.list_page "/search"
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
    @parser.should_receive(:locate).with(@metadata.all_properties)
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
    property.should_receive(:result=).with(true)
    
    @parser.mechanize.stub(:get).and_return fake_document
    @metadata.stub(:all_properties).and_return [property]
    @parser.should_receive(:locate).with(@metadata.all_properties)

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
    property.should_receive(:result=).with(true)
    
    @parser.mechanize.stub(:get).and_return fake_document
    @metadata.stub(:all_properties).and_return [property]
    @parser.should_receive(:locate).with(@metadata.all_properties)

    @parser.parse @metadata

    block_called.should be_true
  end

  it 'should return hash with requested properties' do
    hash = double :results
    fake_parser = double :parser
    fake_document = double :document

    fake_document.should_receive(:parser).and_return fake_parser
    @parser.mechanize.stub(:get).and_return fake_document
    @metadata.should_receive(:flatten).and_return hash
    
    @parser.parse(@metadata).should == hash
  end
end
