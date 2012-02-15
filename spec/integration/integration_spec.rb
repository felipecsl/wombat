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

  it 'should iterate elements' do
    VCR.use_cassette('for_each_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      
      crawler.base_url "https://www.github.com"
      crawler.list_page "/explore"

      crawler.for_each "css=ol.ranked-repositories li" do
        repo 'css=h3'
        description 'css=p.description'
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl

      results["repo"].should =~ ["jairajs89 / Touchy.js", "mcavage / node-restify", "notlion / streetview-stereographic", "twitter / bootstrap", "stolksdorf / Parallaxjs"]
      results["description"].should =~ [
        "node.js REST framework specifically meant for web service APIs",
        "A simple light-weight JavaScript library for dealing with touch events",
        "Shader Toy + Google Map + Panoramic Explorer",
        "HTML, CSS, and JS toolkit from Twitter",
        "a Library for Javascript that allows easy page parallaxing"
      ]
    end
  end

  it  'should crawl xml with namespaces' do
    VCR.use_cassette('xml_with_namespace') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      
      crawler.format :xml
      crawler.base_url "http://ws.audioscrobbler.com"
      crawler.list_page "/2.0/?method=geo.getevents&location=#{URI.escape('San Francisco')}&api_key=060decb474b73437d5bbec37f527ae7b"
      
      crawler.for_each 'xpath=//event' do
        latitude "xpath=./venue/location/geo:point/geo:lat", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
        longitude "xpath=./venue/location/geo:point/geo:long", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl
      
      results["latitude"].should =~ ["37.807775", "37.807717", "37.869784", "37.870873", "37.782348", "37.775529", "37.771079", "37.771079", "37.784963", "37.788978"] 
      results["longitude"].should =~ ["-122.272736", "-122.270059", "-122.267701", "-122.269313", "-122.408059", "-122.437757", "-122.412604", "-122.412604", "-122.418871", "-122.40664"]
    end
  end
end