#coding: utf-8
require 'wombat/dsl/property_group'
require 'wombat/dsl/iterator'
require 'wombat/dsl/follower'
require 'wombat/dsl/headers'

module Wombat
  module DSL
    class Metadata < PropertyGroup
      def initialize
        self[:document_format] = :html
        super
      end

      def base_url(url)
        self[:base_url] = url
      end

      def path(url)
        self[:path] = url
      end

      def document_format(format)
        self[:document_format] = format
      end

      def page(page)
        self[:page] = page
      end
    end
  end
end
