#coding: utf-8
require 'wombat/node_selector'

module Wombat
  module Locators
    # Abstract base class
    class BaseLocator
      include NodeSelector
      
      def initialize(property, context)
        @property = property
        @context = context
      end

      def locate
        # no-op
      end

    protected
      def locate_nodes
        select_nodes @property.selector, @property.namespaces
      end
    end
  end
end