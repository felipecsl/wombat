#coding: utf-8
require 'wombat'

class SampleCrawler
  include Wombat::Crawler

  base_url "http://www.google.com/"
  event_list_page "shows.php"

  event do |e|
    e.title "Sample Event"
    e.description "This event's description"
    e.date DateTime.now.to_date
  end

  venue do |v|
    v.name "Cafe de La Musique"
    v.address "324 Dom Pedro II Street"
  end
end