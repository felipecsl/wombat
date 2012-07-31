require 'wombat/processing/node_selector'

module Wombat
  module DSL
    class Iterator < PropertyGroup
      attr_accessor :wombat_property_selector

      def initialize(name, selector)
        @wombat_property_selector = selector
        
        super(name)
      end

      # So that Property::Locators::Iterator can identify this class
      # as an iterator property.
      def wombat_property_format
        :iterator
      end
    end
  end
end