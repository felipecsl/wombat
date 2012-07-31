require 'wombat/processing/node_selector'

module Wombat
  module DSL
    class Iterator < PropertyGroup
      attr_accessor :selector

      def initialize(name, selector)
        @selector = selector
        
        super(name)
      end

      # So that Property::Locators::Iterator can identify this class
      # as an iterator property.
      def format
        :iterator
      end
    end
  end
end