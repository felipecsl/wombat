#coding: utf-8
require 'wombat/property/locators/property_group'

module Wombat
  module Property
    module Locators
      class Iterator < Base
      	def locate(contex, page = nil)
          super do
            locate_nodes(contex).flat_map do |node|
              Hash.new.tap do |h|
                @property.values
                  .select { |v| v.is_a?(Wombat::DSL::Property) || v.is_a?(Wombat::DSL::PropertyGroup) }
                  .map { |p| Factory.locator_for(p).locate(node, page) }
                  .map { |p| h.merge! p }
              end
            end
          end
        end
      end
    end
  end
end