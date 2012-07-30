#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class List < Base
	    	def locate
	    		super do
	    			locate_nodes.map do |n| 
	    				n.is_a?(String) ? n.strip : n.inner_text.strip
	    			end
	    		end
	    	end
	    end
	  end
  end
end