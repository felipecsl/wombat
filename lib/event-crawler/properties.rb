#coding: utf-8
require 'event-crawler/property'

module EventCrawler
  class Properties
    def initialize
      @properties = []
    end

    def title selector
      @properties << Property.new selector
    end
  end
end