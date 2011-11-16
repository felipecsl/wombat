#coding: utf-8
module EventCrawler
  class PropertyLocator
    attr_accessor :name, :selector, :format, :namespaces, :callback

    def initialize options
      @name = options[:name]
      @selector = options[:selector]
      @format = options[:format]
      @namespaces = options[:namespaces]
      @callback = options[:callback] ? options[:callback] : Proc.new {|val| val }
    end
  end
end