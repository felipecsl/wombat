#coding: utf-8
require 'event-crawler/property_locator'
require 'mechanize'

module EventCrawler
  class Parser
    include PropertyLocator
    attr_accessor :mechanize

    def initialize
      @mechanize = Mechanize.new
    end

    def parse metadata
      metadata.event_props.all_properties.each do |p|
        p.callback.call if p.callback
      end
    end
  end
end