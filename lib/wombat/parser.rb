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
      self.context = parser_for metadata
      original_context = self.context

      metadata.iterators.each do |it|
        select_nodes(it.selector).each do |node|
          self.context = node
          it.parse { |p| locate p }
        end
      end

      self.context = original_context

      metadata.parse { |p| locate p }

      metadata.flatten
    end

    private 
    def parser_for metadata
      url = "#{metadata[:base_url]}#{metadata[:list_page]}"

      if metadata[:format] == :html
        @mechanize.get(url).parser
      else
        Nokogiri::XML RestClient.get(url)
      end
    end
  end
end