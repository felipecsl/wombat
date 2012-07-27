#coding: utf-8
require 'wombat/property/locators/base'
require 'wombat/property/locators/follow'
require 'wombat/property/locators/html'
require 'wombat/property/locators/iterator'
require 'wombat/property/locators/list'
require 'wombat/property/locators/text'

class Wombat::Property::Locators::UnknownTypeException < Exception; end;

module Wombat
	module Property
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
	      		raise Wombat::Property::Locators::UnknownTypeException.new("Unknown property format #{property.format}.")
					end
				end
			end
		end
	end
end