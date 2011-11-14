#coding: utf-8
require 'event-crawler/property'
require 'event-crawler/event_metadata'
require 'event-crawler/parser/resolution'
require 'active_support'

module EventCrawler
  module Crawler
    extend ActiveSupport::Concern

    module InstanceMethods
      
      def crawl
      end

      def supports_city?
      end

    end

    module ClassMethods

      def supported_cities
      end

      def event
        yield if block_given?
      end

      def event_list
      end

      def with_details_page
        yield if block_given?
      end

      def venue
        yield if block_given?
      end

      def city
      end

      def location
        yield if block_given?
      end

      def base_url
      end

      def list_page
      end

      def website_url
      end

      def website_name

      end
    end
  end
end