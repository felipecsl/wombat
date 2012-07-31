#coding: utf-8
require 'wombat'

class SampleCrawler
  include Wombat::Crawler

  base_url "http://www.obaoba.com.br"
  list_page "/porto-alegre/agenda"
  
  event_group "css=div.title-agenda", :iterator do
    event do |e|
      e.title("xpath=.") { |t| t.split(" | ")[1].strip }
      e.date "xpath=//div[@class='scrollable-items']/div[@class='s-item active']//a" do |d|
        DateTime.strptime(d, '%d/%m')
      end
      e.type("xpath=.type") { |t| t.split(" | ").first.strip.casecmp('SHOW') == 0 ? :show : :party }
    end

    venue do |v|
      v.venue_name("xpath=.") { |n| name.split(" | ")[2].strip }
    end
   end
end