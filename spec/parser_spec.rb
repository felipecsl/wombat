require 'spec_helper'

describe EventCrawler::Parser do
  before(:each) do
    @parser = EventCrawler::Parser.new
    @metadata = EventCrawler::Metadata.new
  end

  it 'should request page document with correct url' do
    @metadata[:base_url] = "http://www.google.com"
    @metadata[:event_list_page] = "/search"
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
end
