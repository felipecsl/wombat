module Wombat
  module DSL
    class Headers < PropertyGroup
      attr_accessor :wombat_property_selector

      def initialize(name, selector)
        @wombat_property_selector = selector
        
        super(name)
      end

      # So that Property::Locators::Headers can identify this class
      # as an headers property.
      def wombat_property_format
        :headers
      end
    end
  end
end
