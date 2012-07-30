module Wombat
  module DSL
    class Property
      attr_accessor :name, :selector, :format, :namespaces, :callback

      # TODO: This class should receive method_name, args and block
      # and do the assignment of properties itself, instead of receiving
      # an options hash.
      def initialize(options)
        @name = options[:name]
        @selector = options[:selector]
        @format = options[:format] || :text
        @namespaces = options[:namespaces]
        @callback = options[:callback]
      end
    end
  end
end