#coding: utf-8
require 'event-crawler/property_locator'
require 'mechanize'

module EventCrawler
  class Parser
    include PropertyLocator
    attr_accessor :mechanize, :context

    def initialize
      @mechanize = Mechanize.new
    end

    def parse metadata
      @context = @mechanize.get("#{metadata.base_url}#{metadata.event_list_page}").parser

      locate metadata

      [metadata.event_props, metadata.venue_props, metadata.location_props].flat_map { |p| p.all_properties }.each do |p|
        p.callback.call(p.result) if p.callback
      end
    end
  end
end