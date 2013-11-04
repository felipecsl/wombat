#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Follow < Base
	    	def locate(context, page = nil)
	    		super do
            locate_nodes(context).flat_map do |node|
              target_page = page.click node
              page.back # necessary in order to correctly resolve relative links
              context = target_page.parser

              filter_properties(context, page)
            end
          end
	    	end
	    end
	  end
	end
end
