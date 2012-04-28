#coding: utf-8
require 'wombat/property_container'
require 'wombat/iterator'

module Wombat
  class Metadata < PropertyContainer
    def initialize
      self[:format] = :html
      super
    end

    def base_url(url)
      self[:base_url] = url
    end

    def list_page(url)
      self[:list_page] = url
    end

    def format(format)
      self[:format] = format
    end
  end
end