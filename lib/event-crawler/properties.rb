#coding: utf-8
require 'event-crawler/property'

module EventCrawler
  class Properties
    def initialize
      @properties = []
    end

    def method_missing method, *args, &block
      @properties << Property.new(name: method.to_s, selector: args.first, format: args[1], callback: args[2])
    end

    # TODO: Why I need this?????
    def to_ary
    end

    def get_property name
      @properties.detect {|p| p.name == name }
    end
  end
end