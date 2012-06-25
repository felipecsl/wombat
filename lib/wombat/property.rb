module Wombat
  class Property
    attr_accessor :name, :selector, :format, :namespaces, :callback, :result

    def initialize(options)
      @name = options[:name]
      @selector = options[:selector]
      @format = options[:format]
      @namespaces = options[:namespaces]
      @callback = options[:callback]
    end

    def flatten(depth = nil)
      depth ? result[depth] : result
    end

    def reset
      self.result = nil
    end
  end
end