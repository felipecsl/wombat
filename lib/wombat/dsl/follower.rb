module Wombat
  module DSL
    class Follower < PropertyContainer
      attr_accessor :name, :selector

      def initialize(name, selector)
        @name = name
        @selector = selector
        
        # Explicitly send 0 arguments to superclass constructor
        super()
      end

      def parse(context)
      end
    end
  end
end