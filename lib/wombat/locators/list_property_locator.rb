#coding: utf-8

module Wombat
  module Locators
    class ListPropertyLocator < BaseLocator
    	def locate
    		locate_nodes.map do |n| 
    			n.is_a?(String) ? n.strip : n.inner_text.strip
    		end
    	end
    end
  end
end