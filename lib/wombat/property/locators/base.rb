#coding: utf-8
require 'wombat/processing/node_selector'

module Wombat
  module Property
    module Locators
      # Abstract base class
      class Base
        include Wombat::Processing::NodeSelector

        def initialize(property)
          @property = property
        end

        def locate(context, page = nil)
          @context = context

          raw_data = yield if block_given?
          data = @property.respond_to?(:callback) && @property.callback ? @property.callback.call(raw_data) : raw_data

          @property.wombat_property_name ? { @property.wombat_property_name => data } : data
        end

      protected
        def locate_nodes(context)
          @context = context

          select_nodes @property.wombat_property_selector, @property.wombat_property_namespaces
        end

        def filter_properties(context, page)
          Hash.new.tap do |h|
            @property.values
              .select { |v| v.is_a?(Wombat::DSL::Property) || v.is_a?(Wombat::DSL::PropertyGroup) }
              .map { |p| Factory.locator_for(p).locate(context, page) }
              .map { |p| h.merge! p }
          end
        end
      end
    end
  end
end