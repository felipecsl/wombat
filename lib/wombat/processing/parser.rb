#coding: utf-8
require 'wombat/property/locators/factory'
require 'wombat/processing/node_selector'
require 'mechanize'
require 'restclient'

module Nokogiri
  module XML
    class Document
      attr_accessor :headers
    end
  end
  module HTML
    class Document
      attr_accessor :mechanize_page
    end
  end
end

module Wombat
  module Processing
    module Parser
      attr_accessor :mechanize, :context, :response_code, :page

      def initialize
        @mechanize = Mechanize.new
        @mechanize.set_proxy(*Wombat.proxy_args) if Wombat.proxy_args
      end

      def parse(metadata)
        @context = parser_for metadata

        Wombat::Property::Locators::Factory.locator_for(metadata).locate(@context, @mechanize)
      end

      private
      def parser_for(metadata)
        url = "#{metadata[:base_url]}#{metadata[:path]}"
        page = nil
        parser = nil
        begin
          @page = metadata[:page]

          if metadata[:document_format] == :html
            @page = @mechanize.get(url) unless @page
            parser = @page.parser         # Nokogiri::HTML::Document
            parser.mechanize_page = @page # Mechanize::Page 
            parser.headers = @page.header
          else
            @page = RestClient.get(url) unless @page
            parser = Nokogiri::XML @page
            parser.headers = @page.headers
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
end
