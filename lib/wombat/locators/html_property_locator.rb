#coding: utf-8

module Wombat
  module Locators
    class HtmlPropertyLocator < BaseLocator
    	def locate
    		node = locate_nodes.first
    		node.inner_html.strip
    	end
    end
  end
end