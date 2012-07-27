#coding: utf-8
require 'wombat/locators/base_locator'
require 'wombat/locators/follow_property_locator'
require 'wombat/locators/html_property_locator'
require 'wombat/locators/iterator_property_locator'
require 'wombat/locators/list_property_locator'
require 'wombat/locators/text_property_locator'

class Wombat::PropertyLocatorTypeException < Exception; end;

module Wombat
	module Locators
		module Factory
			def self.locator_for(property, context)
				case(property.format)
				when :text 
					TextPropertyLocator.new(property, context)
				when :list
					ListPropertyLocator.new(property, context)
				when :html 
					HtmlPropertyLocator.new(property, context)
				when :iterator
					IteratorPropertyLocator.new(property, context)
				when :follow
					FollowPropertyLocator.new(property, context)
				else 
      		raise Wombat::PropertyLocatorTypeException.new("Unknown property format #{property.format}.")
				end
			end
		end
	end
end