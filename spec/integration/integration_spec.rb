require 'spec_helper'

describe 'basic crawler setup' do
  it 'should crawl page' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      crawler.gmail "css=.btn-search"
      crawler.base_url "http://www.terra.com.br"
      crawler.list_page '/portal'
      crawler_instance = crawler.new

      results = crawler_instance.crawl

      results.first.result.should == "Buscar"
    end
  end
end