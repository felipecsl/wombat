# coding: utf-8
require 'spec_helper'

describe 'basic crawler setup' do
  it 'should crawl page' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      
      crawler.base_url "http://www.terra.com.br"
      crawler.list_page '/portal'

      crawler.search "css=.btn-search"
      crawler.social do |s|
        s.twitter "css=.ctn-bar li.last"
      end

      crawler.for_each "css=.ctn-links" do
        menu "css=a"
      end

      crawler.subheader "css=h2.ttl-dynamic" do |h|
        h.gsub("London", "Londres")
      end

      crawler_instance = crawler.new

      results = crawler_instance.crawl

      results["search"].should == "Buscar"
      results["menu"].should =~ ["Agenda", "Brasileiro", "Brasil", "Bolsas", "Cinema", "Galerias de Fotos", "Beleza", "Esportes", "Assine o RSS"]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end
end