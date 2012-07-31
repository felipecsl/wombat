module Wombat
  module DSL
    class Property
      attr_accessor :wombat_property_name, :wombat_property_selector, :wombat_property_format, :wombat_property_namespaces, :callback

      def initialize(name, *args, &block)
        @wombat_property_name = name
        @wombat_property_selector = args[0]
        @wombat_property_format = args[1] || :text
        @wombat_property_namespaces = args[2]
        @callback = block
      end

      def selector
        @wombat_property_selector
      end

      def namespaces
        @wombat_property_namespaces
      end

      def format
        @wombat_property_format
      end
    end
  end
end