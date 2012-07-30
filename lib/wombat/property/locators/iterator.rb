#coding: utf-8
require 'wombat/property/locators/property_container'

module Wombat
  module Property
    module Locators
      class Iterator < Base
      	def locate
          super do
            locate_nodes.flat_map do |node|
              Hash.new.tap do |h|
                @property.values
                  .select { |v| v.is_a?(Wombat::DSL::Property) || v.is_a?(Wombat::DSL::PropertyContainer) }
                  .map { |p| Factory.locator_for(p, node).locate }
                  .each { |p| h.merge! p }
              end
            end
          end
        end
      end
    end
  end
end