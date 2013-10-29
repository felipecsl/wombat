#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Follow < Base
	    	def locate(context, page = nil)
	    		super do
            locate_nodes(context).flat_map do |node|
              target_page = page.click node
              if target_page.respond_to? :parser
                context = target_page.parser
              else
                # Mechanize returns different types depending on status code :/
                context = Nokogiri::HTML(target_page.body)
              end

              filter_properties(context, page)
            end
          end
	    	end
	    end
	  end
	end
end
