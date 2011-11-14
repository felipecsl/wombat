module EventCrawler
  class Property
    attr_accessor :name, :value, :format, :namespaces, :callback

    def initialize options
      @name = options[:name]
      @value = options[:value]
      @format = options[:format]
      @namespaces = options[:namespaces]
      @callback = options[:callback] ? options[:callback] : Proc.new {|val| val }
    end
  end
end