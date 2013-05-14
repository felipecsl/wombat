require 'spec_helper'

describe Wombat::Processing::Parser do
  before(:each) do
    crawler = Class.new
    crawler.send(:include, Wombat::Processing::Parser)
    @parser = crawler.new
    @metadata = Wombat::DSL::Metadata.new
  end

  it 'should request page document with correct url' do
    @metadata.base_url "http://www.google.com"
    @metadata.path "/search"
    fake_document = double :document
    fake_parser = double :parser
    fake_header = double :header
    fake_document.should_receive(:parser).and_return(fake_parser)
    fake_document.should_receive(:header).and_return(fake_header)
    fake_parser.should_receive(:headers=)
    @parser.mechanize.should_receive(:get).with("http://www.google.com/search").and_return fake_document

    @parser.parse @metadata
  end

  it 'should correctly parse xml documents' do
    fake_document = double :xml
    fake_parser = double :parser
    fake_headers = double :headers
    @metadata.document_format :xml
    @parser.mechanize.should_not_receive(:get)
    RestClient.should_receive(:get).and_return fake_document
    Nokogiri.should_receive(:XML).with(fake_document).and_return fake_parser
    fake_document.should_receive(:headers).and_return(fake_headers)
    fake_parser.should_receive(:headers=)

    @parser.parse @metadata
  end

  it 'should accept a Mechanize::Page' do
    VCR.use_cassette('basic_crawler_page') do
      m = Mechanize.new
      page = m.get('http://www.terra.com.br/portal')
      @metadata.page page

      @parser.mechanize.should_not_receive(:get)

      @parser.parse @metadata
    end
  end

end
