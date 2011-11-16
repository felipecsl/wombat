#coding: utf-8
module EventCrawler
  class Metadata < Hash
    def initialize
      self[:event_props] = Properties.new
      self[:venue_props] = Properties.new
      self[:location_props] = Properties.new
    end

    def event_props
      self[:event_props]
    end

    def venue_props
      self[:venue_props]
    end

    def location_props
      self[:location_props]
    end

    def method_missing method, *args, &block
      if method.to_s.end_with? '='
        self[method] = args.first
      else
        self[method]
      end
    end
  end
end