require 'wombat/processing/node_selector'

module Wombat
  module DSL
    class Iterator < PropertyContainer
      attr_accessor :name, :selector

      def initialize(name, selector)
        @selector = selector
        
        # Explicitly send 0 arguments to superclass constructor
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