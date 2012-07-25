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
      results["iterator0"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should clear iterators between multiple runs' do
    crawler = Class.new
    crawler.send(:include, Wombat::Crawler)

    crawler.base_url "http://www.terra.com.br"
    crawler.list_page '/portal'

    crawler.for_each "css=.ctn-links" do
      menu "css=a"
    end

    crawler_instance = crawler.new
    result_hash = [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
    results = nil

    VCR.use_cassette('basic_crawler_page') do
      results = crawler_instance.crawl
    end

    results["iterator0"].should == result_hash

    VCR.use_cassette('basic_crawler_page') do
      results = crawler_instance.crawl
    end
    
    results["iterator0"].should == result_hash
  end

  it 'should crawl page through block to class instance crawl method' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      crawler_instance = crawler.new
      results = crawler_instance.crawl do
        base_url "http://www.terra.com.br"
        list_page '/portal'

        search "css=.btn-search"

        social do |s|
          s.twitter "css=.ctn-bar li.last"
        end

        for_each "css=.ctn-links" do
          menu "css=a"
        end

        subheader "css=h2.ttl-dynamic" do |h|
          h.gsub("London", "Londres")
        end
      end

      results["search"].should == "Buscar"
      results["iterator0"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should crawl page through static crawl method' do
    VCR.use_cassette('basic_crawler_page') do
      results = Wombat.crawl do
        base_url "http://www.terra.com.br"
        list_page '/portal'

        search "css=.btn-search"

        social do |s|
          s.twitter "css=.ctn-bar li.last"
        end

        for_each "css=.ctn-links" do
          menu "css=a"
        end

        subheader "css=h2.ttl-dynamic" do |h|
          h.gsub("London", "Londres")
        end
      end

      results["search"].should == "Buscar"
      results["iterator0"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
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
        project do |p|
          p.repo 'css=h3'
          p.description('css=p.description') { |d| d.gsub(/for/, '') }
        end
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl

      results.should == { "iterator0" => [
        { "project" => { "repo" => "jairajs89 / Touchy.js", "description" => "A simple light-weight JavaScript library  dealing with touch events" } },
        { "project" => { "repo" => "mcavage / node-restify", "description" => "node.js REST framework specifically meant  web service APIs" } },
        { "project" => { "repo" => "notlion / streetview-stereographic", "description" => "Shader Toy + Google Map + Panoramic Explorer" } },
        { "project" => { "repo" => "twitter / bootstrap", "description" => "HTML, CSS, and JS toolkit from Twitter" } },
        { "project" => { "repo" => "stolksdorf / Parallaxjs", "description" => "a Library  Javascript that allows easy page parallaxing" } }
      ]}
    end
  end

  it 'should crawl xml with namespaces' do
    VCR.use_cassette('xml_with_namespace') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      
      crawler.document_format :xml
      crawler.base_url "http://ws.audioscrobbler.com"
      crawler.list_page "/2.0/?method=geo.getevents&location=#{URI.escape('San Francisco')}&api_key=060decb474b73437d5bbec37f527ae7b"

      crawler.artist "xpath=//title", :list
      
      crawler.for_each 'xpath=//event' do
        latitude "xpath=./venue/location/geo:point/geo:lat", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
        longitude "xpath=./venue/location/geo:point/geo:long", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl
      iterator = results['iterator0']

      iterator.should == [
        {"latitude"=>"37.807775", "longitude"=>"-122.272736"}, 
        {"latitude"=>"37.807717", "longitude"=>"-122.270059"}, 
        {"latitude"=>"37.869784", "longitude"=>"-122.267701"}, 
        {"latitude"=>"37.870873", "longitude"=>"-122.269313"}, 
        {"latitude"=>"37.782348", "longitude"=>"-122.408059"}, 
        {"latitude"=>"37.775529", "longitude"=>"-122.437757"}, 
        {"latitude"=>"37.771079", "longitude"=>"-122.412604"}, 
        {"latitude"=>"37.771079", "longitude"=>"-122.412604"}, 
        {"latitude"=>"37.784963", "longitude"=>"-122.418871"}, 
        {"latitude"=>"37.788978", "longitude"=>"-122.40664"}
      ]
      
      results["artist"].should =~ ["Davka", "Digitalism (DJ Set)", "Gary Clark Jr.", "Lenny Kravitz", "Little Muddy", "Michael Schenker Group", "The Asteroids Galaxy Tour", "When Indie Attacks", "When Indie Attacks", "YOB"]
    end
  end

  xit 'should follow links' do
    VCR.use_cassette('follow_links') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      
      crawler.document_format :html
      crawler.base_url "https://www.github.com"
      crawler.list_page "/"

      crawler.github 'xpath=//ul[@class="footer_nav"][1]//a', :follow do
        heading 'css=h1'
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl

      results.should == { "github" => [
        { "heading"=>"GitHub helps people build software together."},
        { "heading"=>""},
        { "heading"=>"Features"},
        { "heading"=>"Contact GitHub"},
        { "heading"=>"GitHub Training — Git Training from the Experts"},
        { "heading"=>"GitHub on Your Servers"},
        { "heading"=>"Battle station fully operational"}
      ]}
    end
  end
end