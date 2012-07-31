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
          raw_data = yield if block_given?
          data = @property.respond_to?(:callback) && @property.callback ? @property.callback.call(raw_data) : raw_data 

          @property.wombat_property_name ? { @property.wombat_property_name => data } : data
        end

      protected
        def locate_nodes
          select_nodes @property.selector, @property.namespaces
        end
      end
    end
  end
end