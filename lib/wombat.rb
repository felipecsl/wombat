#coding: utf-8

require 'wombat/crawler'

module Wombat
	def self.crawl(&block)
		klass = Class.new
		klass.send(:include, Wombat::Crawler)
		klass.new.crawl(&block)
	end
end