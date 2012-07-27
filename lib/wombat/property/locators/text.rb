#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Text < Base
	    	def locate
	    		node = locate_nodes.first
	    		node.is_a?(String) ? node.strip : node.inner_text.strip
	    	end
	    end
	  end
  end
end