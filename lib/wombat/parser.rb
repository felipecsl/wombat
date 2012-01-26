#coding: utf-8
require 'wombat/property_locator'
require 'mechanize'

module Wombat
  class Parser
    include PropertyLocator
    attr_accessor :mechanize, :context

    def initialize
      @mechanize = Mechanize.new
    end

    def parse metadata
      @context = @mechanize.get("#{metadata[:base_url]}#{metadata[:event_list_page]}").parser

      locate metadata

      metadata.all_properties.each do |p|
        p.callback.call(p.result) if p.callback
      end
    end
  end
end