#coding: utf-8
require 'wombat/dsl/property_container'
require 'wombat/dsl/iterator'

module Wombat
  module DSL
    class Metadata < PropertyContainer
      def initialize
        self[:document_format] = :html
        super
      end

      def base_url(url)
        self[:base_url] = url
      end

      def list_page(url)
        self[:list_page] = url
      end

      def document_format(format)
        self[:document_format] = format
      end
    end
  end
end