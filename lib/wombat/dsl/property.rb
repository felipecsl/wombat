module Wombat
  module DSL
    class Property
      attr_accessor :wombat_property_name, :selector, :format, :namespaces, :callback

      def initialize(name, *args, &block)
        @wombat_property_name = name
        @selector = args[0]
        @format = args[1] || :text
        @namespaces = args[2]
        @callback = block
      end
    end
  end
end