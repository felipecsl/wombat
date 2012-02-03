#coding: utf-8
require 'wombat'

class SampleCrawler
  include Wombat::Crawler

  base_url "http://www.obaoba.com.br"
  list_page "/porto-alegre/agenda"
  
  for_each "css=div.title-agenda" do
    event do |e|
      e.title("xpath=.") { |t| t.split(" | ")[1].strip }
      e.date "xpath=//div[@class='scrollable-items']/div[@class='s-item active']//a" do |d|
        DateTime.strptime(d, '%d/%m')
      end
      e.type("xpath=.") { |t| t.split(" | ").first.strip.casecmp('SHOW') == 0 ? :show : :party }
    end

    venue do |v|
      v.name("xpath=.") { |n| name.split(" | ")[2].strip }
    end

    follow_links "xpath=.//a[1]/@href" do
      event { |e| e.description "css=#main-node-content", :html }
      venue do |v|
        v.phone "css=span.tel .value"
        v.image "xpath=//div[@id='article-image']/div/img/@src"
      end

      location do |l|
        l.city "css=span.locality"
        l.street("css=span.street-address") { |s| s.gsub(/\n/, '').gsub(/  /, '') }
      end
    end
  end
end