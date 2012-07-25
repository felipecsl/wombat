#coding: utf-8
require 'wombat/metadata'
require 'wombat/property'
require 'wombat/parser'
require 'active_support'
require 'date'

module Wombat
  module Crawler
    include Parser
    extend ActiveSupport::Concern

    def crawl(&block)
      if block
        @metadata_dup = self.class.send(:metadata).clone
        instance_eval do
          alias :old_method_missing :method_missing
          def method_missing method, *args, &block
            @metadata_dup.send method, *args, &block
          end
        end
        self.instance_eval &block
        parsed = parse @metadata_dup
        instance_eval do
          alias :method_missing :old_method_missing
          remove_instance_variable :@metadata_dup
        end
        parsed
      else
        parse self.class.send(:metadata)
      end
    end

    alias_method :scrape, :crawl

    def method_missing(method, *args, &block)
      self.class.send method, *args, &block
    end

    def for_each(selector, &block)
      self.class.for_each selector, &block
    end

    def follow_links(selector, options, &block)
      self.class.follow_links selector, options, &block
    end

    module ClassMethods
      def method_missing(method, *args, &block)
        metadata.send method, *args, &block
      end

      def for_each(selector, &block)
        metadata.for_each(selector).instance_eval(&block) if block
      end

      def follow_links(selector, options, &block)
        
      end

      def follow_links(selector)

      end

      def to_ary
      end

      private
      def metadata
        @metadata ||= Metadata.new
      end
    end
  end
end