 #coding: utf-8
require 'wombat/property_locator'
require 'mechanize'

module Wombat
  module Parser
    include PropertyLocator
    attr_accessor :mechanize, :context

    def initialize
      @mechanize = Mechanize.new
    end

    def parse metadata
      self.context = @mechanize.get("#{metadata[:base_url]}#{metadata[:list_page]}").parser
      original_context = self.context

      metadata.iterators.each do |it|
        select_nodes(it.selector).each do |n|
          self.context = n
          it.all_properties.each do |p|
            p.result ||= []
            p.result << locate_first(p)
          end
        end
      end

      self.context = original_context

      metadata.all_properties.each do |p|
        result = locate_first p
        p.result = p.callback ? p.callback.call(result) : result
      end

      metadata.flatten
    end
  end
end