#coding: utf-8
module EventCrawler
  class Metadata < Hash
    def initialize
      self[:event_props] = Properties.new
      self[:venue_props] = Properties.new
      self[:location_props] = Properties.new
    end

    [:event, :venue, :location].each do |m|
      define_method(m) do
        self["#{m.to_s}_props".to_sym]
      end
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