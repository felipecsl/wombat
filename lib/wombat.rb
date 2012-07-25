#coding: utf-8

require 'wombat/crawler'

module Wombat
	class << self
		def crawl(&block)
			klass = Class.new
			klass.send(:include, Wombat::Crawler)
			klass.new.crawl(&block)
		end
		
		alias_method :scrape, :crawl
	end
end