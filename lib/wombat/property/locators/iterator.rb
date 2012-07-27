#coding: utf-8

module Wombat
  module Property
    module Locators
      class Iterator < Base
      	def locate
      		it.reset # Clean up iterator results before starting

          locate_nodes.each do |node|
            # @context = node
            # it.parse { |p| locate p }
          end
      	end
      end
    end
  end
end