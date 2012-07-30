#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Html < Base
	    	def locate
	    		node = locate_nodes.first
	    		super { node.inner_html.strip }
	    	end
	    end
	  end
  end
end