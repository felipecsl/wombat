#coding: utf-8

require 'wombat/crawler'

module Wombat
	class << self

    attr_reader :proxy_args

		def crawl(&block)
			klass = Class.new
			klass.send(:include, Wombat::Crawler)
			klass.new.crawl(&block)
		end

    def configure
      yield self
    end

    def set_proxy(*args)
      @proxy_args = args
    end

		alias_method :scrape, :crawl
	end
end