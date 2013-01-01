#coding: utf-8
require 'wombat/property/locators/factory'
require 'wombat/processing/node_selector'
require 'mechanize'
require 'restclient'
require 'vcr'

module Nokogiri
  module XML
    class Document
      attr_accessor :headers
    end
  end
end

module Wombat
  module Processing
    module Parser
      attr_accessor :mechanize, :context, :response_code, :page

      def initialize
        @mechanize = Mechanize.new
        VCR.configure do |c|
          c.cassette_library_dir = 'fixtures/vcr_cassettes'
          c.allow_http_connections_when_no_cassette = true          
          c.hook_into :fakeweb
        end
      end

      def set_proxy(host, port)
      	@mechanize.set_proxy host, port
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
          if metadata[:document_format] == :html
            if metadata[:should_cache] == :true
              VCR.use_cassette('parser', :record => :new_episodes) do
                @page = @mechanize.get(url)
              end
            else            
                @page = @mechanize.get(url)
            end
  
            parser = @page.parser
            parser.headers = @page.header
          else
            if metadata[:should_cache] == :true
              VCR.use_cassette('parser', :record => :new_episodes) do
                @page = RestClient.get(url)
              end
            else
                @page = RestClient.get(url)
            end
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
