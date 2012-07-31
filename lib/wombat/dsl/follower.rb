module Wombat
  module DSL
    class Follower < PropertyGroup
      attr_accessor :wombat_property_name, :selector

      def initialize(name, selector)
        @selector = selector
        
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