#coding: utf-8
require 'wombat/property/locators/property_group'

module Wombat
  module Property
    module Locators
      class Iterator < Base
      	def locate(contex, page = nil)
          super do
            locate_nodes(contex).flat_map do |node|
              filter_properties(node, page)
            end
          end
        end
      end
    end
  end
end