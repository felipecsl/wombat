#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Follow < Base
	    	def locate
	    		super do
            locate_nodes.flat_map do |node|
              
            end
          end
	    	end
	    end
	  end
	end
end