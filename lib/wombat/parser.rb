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
      @context = @mechanize.get("#{metadata[:base_url]}#{metadata[:list_page]}").parser

      props = metadata.all_properties

      locate props

      props.each do |p|
        p.result = p.callback.call(p.result) if p.callback
      end

      metadata.flatten
    end
  end
end