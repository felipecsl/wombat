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

      results["search"].should eq "Buscar"
      results["links"].should eq [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should eq "Londres 2012"
      results["social"]["twitter"].should eq "Verão"
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

      results["search"].should eq "Buscar"
      results["links"].should eq [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should eq "Londres 2012"
      results["social"]["twitter"].should eq "Verão"
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

      results["search"].should eq "Buscar"
      results["links"].should eq [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should eq "Londres 2012"
      results["social"]["twitter"].should eq "Verão"
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

    results["links"].should eq result_hash

    VCR.use_cassette('basic_crawler_page') do
      results = crawler_instance.crawl
    end

    results["links"].should eq result_hash
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

      results["search"].should eq "Buscar"
      results["links"].should eq [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should eq "Londres 2012"
      results["social"]["twitter"].should eq "Verão"
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

      results["search"].should eq "Buscar"
      results["links"].should eq [{"menu"=>"Agenda"}, {"menu"=>"Brasileiro"}, {"menu"=>"Brasil"}, {"menu"=>"Bolsas"}, {"menu"=>"Cinema"}, {"menu"=>"Galerias de Fotos"}, {"menu"=>"Beleza"}, {"menu"=>"Esportes"}, {"menu"=>"Assine o RSS"}]
      results["subheader"].should eq "Londres 2012"
      results["social"]["twitter"].should eq "Verão"
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

      results.should eq({ "repos" => [
        { "project" => { "repo" => "jairajs89 / Touchy.js", "description" => "A simple light-weight JavaScript library  dealing with touch events" } },
        { "project" => { "repo" => "mcavage / node-restify", "description" => "node.js REST framework specifically meant  web service APIs" } },
        { "project" => { "repo" => "notlion / streetview-stereographic", "description" => "Shader Toy + Google Map + Panoramic Explorer" } },
        { "project" => { "repo" => "twitter / bootstrap", "description" => "HTML, CSS, and JS toolkit from Twitter" } },
        { "project" => { "repo" => "stolksdorf / Parallaxjs", "description" => "a Library  Javascript that allows easy page parallaxing" } },
        { "project" => { "repo" => nil, "description" => nil}}
      ]})
    end
  end

  it 'should crawl xml with namespaces' do
    VCR.use_cassette('xml_with_namespace') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.document_format :xml
      crawler.base_url "http://ws.audioscrobbler.com"
      crawler.path "/2.0/?method=geo.getevents&location=#{URI.encode_www_form_component('San Francisco')}&api_key=060decb474b73437d5bbec37f527ae7b"
      crawler.artist "xpath=//title", :list
      crawler.location 'xpath=//event', :iterator do
        latitude "xpath=./venue/location/geo:point/geo:lat", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
        longitude "xpath=./venue/location/geo:point/geo:long", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
      end

      crawler_instance = crawler.new
      results = crawler_instance.crawl
      iterator = results['location']

      iterator.should eq([
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
      ])

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

      results.should eq({
        "github" => [
          { "heading"=>"GitHub helps people build software together." },
          { "heading"=>nil },
          { "heading"=>"Features" },
          { "heading"=>"Contact GitHub" },
          { "heading"=>"GitHub Training — Git Training from the Experts" },
          { "heading"=>"GitHub on Your Servers" },
          { "heading"=>"Loading..." }
        ]
      })
    end
  end

  it 'should follow links - issue #53' do
    VCR.use_cassette('follow_links_v2', :preserve_exact_body_bytes => true) do
      result = Wombat.crawl do
        base_url "http://www.icy-veins.com/"
        path "heroes/hero-guides"

        heroes  "css=.page_content .nav_content_block_entry_heroes_hero", :iterator do
          name "xpath=."
          builds "xpath=./a", :follow do
              title "css=h1"
          end
        end
      end

      expect(result).to eq(
        {"heroes"=>
          [{"name"=>"Abathur",
            "builds"=>[{"title"=>"Abathur Build Guide “You. Enhanced. Improved.”"}]},
           {"name"=>"Anub'arak",
            "builds"=>[{"title"=>"Anub'arak Build Guide “Time is fleeting.”"}]},
           {"name"=>"Artanis",
            "builds"=>[{"title"=>"Artanis Build Guide “Direct my wrath.”"}]},
           {"name"=>"Arthas",
            "builds"=>[{"title"=>"Arthas Build Guide “Frostmourne hungers.”"}]},
           {"name"=>"Azmodan",
            "builds"=>[{"title"=>"Azmodan Build Guide “I shall rule alone!”"}]},
           {"name"=>"Brightwing",
            "builds"=>
             [{"title"=>"Brightwing Build Guide “You don't want to be my enemy!”"}]},
           {"name"=>"Chen",
            "builds"=>[{"title"=>"Chen Build Guide “I bring Pandamonium!”"}]},
           {"name"=>"Cho",
            "builds"=>
             [{"title"=>
                "Cho Build Guide “This Nexus, all its power... it will be MINE!”"}]},
           {"name"=>"Diablo",
            "builds"=>
             [{"title"=>"Diablo Build Guide “Kneel before the Lord of Terror.”"}]},
           {"name"=>"E.T.C.",
            "builds"=>[{"title"=>"E.T.C. Build Guide “You can't kill the metal!”"}]},
           {"name"=>"Falstad",
            "builds"=>[{"title"=>"Falstad Build Guide “Time to drop the hammer!”"}]},
           {"name"=>"Gall",
            "builds"=>
             [{"title"=>
                "Gall Build Guide “Those who oppose me invite their own demise!”"}]},
           {"name"=>"Gazlowe",
            "builds"=>[{"title"=>"Gazlowe Build Guide “Hey, time is money friend.”"}]},
           {"name"=>"Greymane",
            "builds"=>[{"title"=>"Greymane Build Guide “I am the alpha!”"}]},
           {"name"=>"Illidan",
            "builds"=>[{"title"=>"Illidan Build Guide “Now I am complete!”"}]},
           {"name"=>"Jaina",
            "builds"=>[{"title"=>"Jaina Build Guide “I'm here to help.”"}]},
           {"name"=>"Johanna",
            "builds"=>[{"title"=>"Johanna Build Guide “The Crusade marches on!”"}]},
           {"name"=>"Kael'thas",
            "builds"=>[{"title"=>"Kael'thas Build Guide “Anar'alah belore!”"}]},
           {"name"=>"Kerrigan",
            "builds"=>[{"title"=>"Kerrigan Build Guide “Long live the real Queen.”"}]},
           {"name"=>"Kharazim",
            "builds"=>[{"title"=>"Kharazim Build Guide “Feel the wrath of Ytar!”"}]},
           {"name"=>"Leoric",
            "builds"=>
             [{"title"=>"Leoric Build Guide “All will suffer as I have suffered!”"}]},
           {"name"=>"Li Li",
            "builds"=>[{"title"=>"Li Li Build Guide “Ready for adventure!”"}]},
           {"name"=>"Lt. Morales",
            "builds"=>
             [{"title"=>
                "Lt. Morales Build Guide “I protect every member of my squad!”"}]},
           {"name"=>"Lunara",
            "builds"=>[{"title"=>"Lunara Build Guide “Taste my spear!”"}]},
           {"name"=>"Malfurion",
            "builds"=>
             [{"title"=>"Malfurion Build Guide “Nature will rise against you!”"}]},
           {"name"=>"Muradin",
            "builds"=>[{"title"=>"Muradin Build Guide “It's hammer time!”"}]},
           {"name"=>"Murky",
            "builds"=>[{"title"=>"Murky Build Guide “Mrglrglmrglmrrrlggg!”"}]},
           {"name"=>"Nazeebo",
            "builds"=>[{"title"=>"Nazeebo Build Guide “The spirits speak to me.”"}]},
           {"name"=>"Nova",
            "builds"=>
             [{"title"=>"Nova Build Guide “Ready to have your mind blown?”"}]},
           {"name"=>"Raynor",
            "builds"=>[{"title"=>"Raynor Build Guide “Hit 'em hard and fast.”"}]},
           {"name"=>"Rehgar",
            "builds"=>[{"title"=>"Rehgar Build Guide “To the Arena!”"}]},
           {"name"=>"Rexxar",
            "builds"=>[{"title"=>"Rexxar Build Guide “The beasts obey me!”"}]},
           {"name"=>"Sgt. Hammer",
            "builds"=>[{"title"=>"Sgt. Hammer Build Guide “Napalm's airborne!”"}]},
           {"name"=>"Sonya",
            "builds"=>[{"title"=>"Sonya Build Guide “Time to die!”"}]},
           {"name"=>"Stitches",
            "builds"=>[{"title"=>"Stitches Build Guide “ROAAAARR!”"}]},
           {"name"=>"Sylvanas",
            "builds"=>[{"title"=>"Sylvanas Build Guide “Let none survive!”"}]},
           {"name"=>"Tassadar",
            "builds"=>[{"title"=>"Tassadar Build Guide “Executor, I stand ready!”"}]},
           {"name"=>"The Butcher",
            "builds"=>[{"title"=>"The Butcher Build Guide “Fresh meat!”"}]},
           {"name"=>"Thrall",
            "builds"=>
             [{"title"=>"Thrall Build Guide “The Elements will destroy you!”"}]},
           {"name"=>"Tychus",
            "builds"=>[{"title"=>"Tychus Build Guide “So, you gonna bark all day?”"}]},
           {"name"=>"Tyrael",
            "builds"=>[{"title"=>"Tyrael Build Guide “I am Justice itself!”"}]},
           {"name"=>"Tyrande",
            "builds"=>
             [{"title"=>"Tyrande Build Guide “Feel the wrath of the Heavens!”"}]},
           {"name"=>"Uther",
            "builds"=>[{"title"=>"Uther Build Guide “I will fight with honor!”"}]},
           {"name"=>"Valla",
            "builds"=>[{"title"=>"Valla Build Guide “Be vewy, vewy quiet...”"}]},
           {"name"=>"Zagara",
            "builds"=>[{"title"=>"Zagara Build Guide “The Swarm hungers.”"}]},
           {"name"=>"Zeratul",
            "builds"=>[{"title"=>"Zeratul Build Guide “I serve the Xel'naga.”"}]}]})
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
