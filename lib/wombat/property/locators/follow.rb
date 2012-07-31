#coding: utf-8

module Wombat
	module Property
	  module Locators
	    class Follow < Base
	    	def locate(context, page = nil)
	    		super do
            locate_nodes(context).flat_map do |node|
              target_page = page.click node
              context = target_page.parser

              Hash.new.tap do |h|
                @property.values
                  .select { |v| v.is_a?(Wombat::DSL::Property) || v.is_a?(Wombat::DSL::PropertyGroup) }
                  .map { |p| Factory.locator_for(p).locate(context, page) }
                  .map { |p| h.merge! p }
              end
            end
          end
	    	end
	    end
	  end
	end
end