#coding: utf-8
require 'wombat'

class SampleCrawler
  include Wombat::Crawler

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