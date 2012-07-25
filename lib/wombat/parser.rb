#coding: utf-8
require 'wombat/property_locator'
require 'mechanize'
require 'restclient'

module Wombat
  module Parser
    include PropertyLocator
    attr_accessor :mechanize, :context, :response_code, :page

    def initialize
      @mechanize = Mechanize.new
    end

    def parse(metadata)
      @context = parser_for metadata
      original_context = @context

      metadata.iterators.each do |it|
        it.reset # Clean up iterator results before starting
        select_nodes(it.selector).each do |node|
          @context = node
          it.parse { |p| locate p }
        end
      end

      @context = original_context

      metadata.parse { |p| locate p }

      metadata.flatten
    end

    private
    def parser_for(metadata)
      url = "#{metadata[:base_url]}#{metadata[:list_page]}"
      page = nil
      parser = nil
      begin
        if metadata[:document_format] == :html
          @page = @mechanize.get(url)
          parser = @page.parser
        else
          @page = RestClient.get(url)
          parser = Nokogiri::XML @page
        end
        @response_code = @page.code.to_i if @page.respond_to? :code
        parser
      rescue
        if $!.respond_to? :http_code
          @response_code = $!.http_code.to_i
        elsif $!.respond_to? :response_code
          @response_code = $!.response_code.to_i
        end
        raise $!
      end
    end
  end
end