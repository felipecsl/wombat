module Wombat
  module DSL
    class Property
      attr_accessor :wombat_property_name, :selector, :format, :namespaces, :callback

      # TODO: This class should receive method_name, args and block
      # and do the assignment of properties itself, instead of receiving
      # an options hash.
      def initialize(options)
        @wombat_property_name = options[:wombat_property_name]
        @selector = options[:selector]
        @format = options[:format] || :text
        @namespaces = options[:namespaces]
        @callback = options[:callback]
      end
    end
  end
end