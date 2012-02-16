 #coding: utf-8
require 'wombat/property_locator'
require 'mechanize'
require 'restclient'

module Wombat
  module Parser
    include PropertyLocator
    attr_accessor :mechanize, :context

    def initialize
      @mechanize = Mechanize.new
    end

    def parse metadata
      self.context = get_parser metadata
      original_context = self.context

      metadata.iterators.each do |it|
        select_nodes(it.selector).each do |n|
          self.context = n
          it.all_properties.each do |p|
            p.result ||= []
            result = locate(p)
            p.result << result if result
          end
        end
      end

      self.context = original_context

      metadata.all_properties.each do |p|
        result = locate p
        p.result = p.callback ? p.callback.call(result) : result
      end

      metadata.flatten
    end

    private 
    def get_parser metadata
      url = "#{metadata[:base_url]}#{metadata[:list_page]}"

      if metadata[:format] == :html
        @mechanize.get(url).parser
      else
        Nokogiri::XML RestClient.get(url)
      end
    end
  end
end