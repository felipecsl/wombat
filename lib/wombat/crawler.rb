#coding: utf-8
require 'wombat/dsl/metadata'
require 'wombat/dsl/property'
require 'wombat/processing/parser'
require 'active_support'
require 'date'

module Wombat
  module Crawler
    include Processing::Parser
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :metadata
      end
      self.metadata = DSL::Metadata.new
    end

    def crawl(url = nil, options = {}, &block)
      if block
        @metadata_dup = self.class.send(:metadata).clone
        instance_eval do
          alias :old_method_missing :method_missing
          def method_missing method, *args, &block
            @metadata_dup.send method, *args, &block
          end
        end
        self.instance_eval &block
        parsed = parse(@metadata_dup, url, options)
        instance_eval do
          alias :method_missing :old_method_missing
          remove_instance_variable :@metadata_dup
        end
        parsed
      else
        parse(self.class.send(:metadata), url, options)
      end
    end

    alias_method :scrape, :crawl

    def method_missing(method, *args, &block)
      self.class.send method, *args, &block
    end

    module ClassMethods
      def method_missing(method, *args, &block)
        metadata.send method, *args, &block
      end

      def to_ary
      end

      def inherited(subclass)
        subclass.metadata = self.metadata.clone
      end
    end
  end
end
