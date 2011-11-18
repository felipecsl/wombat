module EventCrawler
  class Property
    attr_accessor :name, :selector, :format, :namespaces, :callback

    def initialize options
      @name = options[:name]
      @selector = options[:selector]
      @format = options[:format]
      @namespaces = options[:namespaces]
      @callback = options[:callback]
    end
  end
end