module EventCrawler
  class Property
    attr_accessor :name, :selector, :format, :callback

    def initialize options
      @name = options[:name]
      @selector = options[:selector]
      @format = options[:format]
      @callback = options[:callback]
    end
  end
end