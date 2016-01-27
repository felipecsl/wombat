# coding: utf-8
require 'spec_helper'

describe 'basic crawler setup' do
  it 'should crawl page' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.base_url "http://www.terra.com.br"
      crawler.path '/portal'

      crawler.search "css=.btn-search"
      crawler.social do
        twitter "css=.ctn-bar li.last"
      end
      crawler.links "css=.ctn-links", :iterator do
        menu "css=a"
      end
      crawler.subheader "css=h2.ttl-dynamic" do |h|
        h.gsub("London", "Londres")
      end

      crawler_instance = crawler.new

      results = crawler_instance.crawl

      results["search"].should == "Buscar"
      results["links"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should crawl a Mechanize::Page' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      m = Mechanize.new
      mp = m.get "http://www.terra.com.br/portal"
      crawler.page mp

      crawler.search "css=.btn-search"
      crawler.social do
        twitter "css=.ctn-bar li.last"
      end
      crawler.links "css=.ctn-links", :iterator do
        menu "css=a"
      end
      crawler.subheader "css=h2.ttl-dynamic" do |h|
        h.gsub("London", "Londres")
      end

      crawler_instance = crawler.new

      results = crawler_instance.crawl

      results["search"].should == "Buscar"
      results["links"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should support hash based selectors' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.base_url "http://www.terra.com.br"
      crawler.path '/portal'

      crawler.search css: ".btn-search"
      crawler.social do
        twitter css: ".ctn-bar li.last"
      end
      crawler.links({css: ".ctn-links"}, :iterator) do
        menu css: "a"
      end
      crawler.subheader css: "h2.ttl-dynamic" do |h|
        h.gsub("London", "Londres")
      end

      crawler_instance = crawler.new

      results = crawler_instance.crawl

      results["search"].should == "Buscar"
      results["links"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should clear iterators between multiple runs' do
    crawler = Class.new
    crawler.send(:include, Wombat::Crawler)

    crawler.base_url "http://www.terra.com.br"
    crawler.path '/portal'

    crawler.links "css=.ctn-links", :iterator do
      menu "css=a"
    end

    crawler_instance = crawler.new
    result_hash = [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
    results = nil

    VCR.use_cassette('basic_crawler_page') do
      results = crawler_instance.crawl
    end

    results["links"].should == result_hash

    VCR.use_cassette('basic_crawler_page') do
      results = crawler_instance.crawl
    end

    results["links"].should == result_hash
  end

  it 'should crawl page through block to class instance crawl method' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      crawler_instance = crawler.new
      results = crawler_instance.crawl do
        base_url "http://www.terra.com.br"
        path '/portal'

        search "css=.btn-search"

        social do
          twitter "css=.ctn-bar li.last"
        end

        links "css=.ctn-links", :iterator do
          menu "css=a"
        end

        subheader "css=h2.ttl-dynamic" do |h|
          h.gsub("London", "Londres")
        end
      end

      results["search"].should == "Buscar"
      results["links"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should crawl page through static crawl method' do
    VCR.use_cassette('basic_crawler_page') do
      results = Wombat.crawl do
        base_url "http://www.terra.com.br"
        path '/portal'

        search "css=.btn-search"

        social do
          twitter "css=.ctn-bar li.last"
        end

        links "css=.ctn-links", :iterator do
          menu "css=a"
        end

        subheader "css=h2.ttl-dynamic" do |h|
          h.gsub("London", "Londres")
        end
      end

      results["search"].should == "Buscar"
      results["links"].should == [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should == "Londres 2012"
      results["social"]["twitter"].should == "Verão"
    end
  end

  it 'should iterate elements' do
    VCR.use_cassette('for_each_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.base_url "https://www.github.com"
      crawler.path "/explore"

      crawler.repos "css=ol.ranked-repositories>li", :iterator do
        project do
          repo 'css=h3'
          description('css=p.description') { |d| d ? d.gsub(/for/, '') : nil }
        end
      end

      results = crawler.new.crawl

      results.should == { "repos" => [
        { "project" => { "repo" => "jairajs89 / Touchy.js", "description" => "A simple light-weight JavaScript library  dealing with touch events" } },
        { "project" => { "repo" => "mcavage / node-restify", "description" => "node.js REST framework specifically meant  web service APIs" } },
        { "project" => { "repo" => "notlion / streetview-stereographic", "description" => "Shader Toy + Google Map + Panoramic Explorer" } },
        { "project" => { "repo" => "twitter / bootstrap", "description" => "HTML, CSS, and JS toolkit from Twitter" } },
        { "project" => { "repo" => "stolksdorf / Parallaxjs", "description" => "a Library  Javascript that allows easy page parallaxing" } },
        { "project" => { "repo" => nil, "description" => nil}}
      ]}
    end
  end

  it 'should crawl xml with namespaces' do
    VCR.use_cassette('xml_with_namespace') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.document_format :xml
      crawler.base_url "http://ws.audioscrobbler.com"
      crawler.path "/2.0/?method=geo.getevents&location=#{URI.escape('San Francisco')}&api_key=060decb474b73437d5bbec37f527ae7b"

      crawler.artist "xpath=//title", :list

      crawler.location 'xpath=//event', :iterator do
        latitude "xpath=./venue/location/geo:point/geo:lat", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
        longitude "xpath=./venue/location/geo:point/geo:long", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl
      iterator = results['location']

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

  it 'should follow links' do
    VCR.use_cassette('follow_links') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.base_url "https://www.github.com"
      crawler.path "/"

      crawler.github 'xpath=//ul[@class="footer_nav"][1]//a', :follow do
        heading 'css=h1'
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl

      results.should == {
        "github" => [
          { "heading"=>"GitHub helps people build software together." },
          { "heading"=>nil },
          { "heading"=>"Features" },
          { "heading"=>"Contact GitHub" },
          { "heading"=>"GitHub Training — Git Training from the Experts" },
          { "heading"=>"GitHub on Your Servers" },
          { "heading"=>"Loading..." }
        ]
      }
    end
  end

  it 'should make post requests if needed' do
    VCR.use_cassette('make_post_request') do
      data = { your_name: "Name" }
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      crawler.base_url "http://hroch486.icpf.cas.cz"
      crawler.path "/cgi-bin/echo.pl"
      crawler.http_method :post
      crawler.data data

      crawler.my_name 'css=ul:last li:last'

      crawler_instance = crawler.new
      results = crawler_instance.crawl

      results["my_name"].should eq("your_name = Name")
    end
  end

  it 'should let the url be passed as an argument to crawl' do
    VCR.use_cassette('basic_crawler_page') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)
      crawler.send(:title, 'xpath=//head/title')
      crawler_instance = crawler.new
      results = crawler_instance.crawl('http://www.terra.com.br/portal')
      results['title'].should eq('Terra - Notícias, vídeos, esportes, economia, diversão, música, moda, fotolog, blog, chat')
    end
  end
end
