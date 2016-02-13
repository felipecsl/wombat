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
    class Element
      attr_accessor :mechanize_page
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
      HTTP_METHODS = [:get, :post, :put, :patch, :delete, :head]
      attr_accessor :mechanize, :context, :response_code, :page

      def initialize
        # http://stackoverflow.com/questions/6918277/ruby-mechanize-web-scraper-library-returns-file-instead-of-page
        @mechanize = Mechanize.new { |a|
          a.post_connect_hooks << lambda { |_,_,response,_|
            if response.content_type.nil? || response.content_type.empty?
              response.content_type = 'text/html'
            end
          }
        }
        @mechanize.set_proxy(*Wombat.proxy_args) if Wombat.proxy_args
        @mechanize.user_agent = Wombat.user_agent if Wombat.user_agent
        @mechanize.user_agent_alias = Wombat.user_agent_alias if Wombat.user_agent_alias
      end

      def parse(metadata, url=nil)
        @context = parser_for(metadata, url)

        Wombat::Property::Locators::Factory.locator_for(metadata).locate(@context, @mechanize)
      end

      private
      def parser_for(metadata, url)
        url ||= "#{metadata[:base_url]}#{metadata[:path]}"
        page = nil
        parser = nil
        _method = method_from(metadata[:http_method])
        data = metadata[:data]
        args = [url, data].compact
        begin
          @page = metadata[:page]

          if metadata[:document_format] == :html
            @page = @mechanize.public_send(_method, *args) unless @page
            parser = @page.parser         # Nokogiri::HTML::Document
            parser.mechanize_page = @page # Mechanize::Page
            parser.headers = @page.header
          else
            @page = RestClient.public_send(_method, *args) unless @page
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

      def method_from(_method)
        return :get if _method.nil?
        HTTP_METHODS.detect(->{:get}){ |i| i == _method.downcase.to_sym }
      end
    end
  end
end
