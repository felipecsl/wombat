#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Follow < Base
	    	def locate(context, page = nil)
	    		super do
            locate_nodes(context).flat_map do |node|
              retried = false
              begin
                # Certain erroneous pages contain http 
                # links with relative href attribute, 
                # while browsers actually use them as 
                # absolute.
                # So, let wombat try that approach when 
                # loading relative link fails.
                #
                target_page = page.click node
                context = target_page.parser

                filter_properties(context, page)
              rescue Mechanize::ResponseCodeError => e
                # Either the page is unavailable, or
                # the link is mistakenly relative
                #
                raise e if retried
                
                # Give it a try first time
                href = node.attributes && node.attributes["href"]
                if href.respond_to? :value
                  href.value = '/' + href.value unless 
                    href.value.start_with? '/'
                  retried = true
                  retry
                else
                  raise e
                end
              end
            end
          end
	    	end
	    end
	  end
	end
end
