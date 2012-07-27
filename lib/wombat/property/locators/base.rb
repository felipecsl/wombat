#coding: utf-8
require 'wombat/processing/node_selector'

module Wombat
  module Property
    module Locators
      # Abstract base class
      class Base
        include Wombat::Processing::NodeSelector
        
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
end