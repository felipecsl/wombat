#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Follow < Base
	    	def locate(context, page = nil)
	    		super do
            locate_nodes(context).flat_map do |node|
              mechanize_page = context.mechanize_page
              link = Mechanize::Page::Link.new(node, page, mechanize_page)
              target_page = page.click link
              context = target_page.parser
              context.mechanize_page = mechanize_page

              filter_properties(context, page)
            end
          end
	    	end
	    end
	  end
	end
end
