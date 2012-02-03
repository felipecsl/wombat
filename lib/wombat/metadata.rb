#coding: utf-8
require 'wombat/property_container'

module Wombat
  class Metadata < PropertyContainer
    def initialize
      [:event, :venue, :location].each do |p|
        self["#{p.to_s}_props".to_sym] = PropertyContainer.new
      end
    end

    [:event, :venue, :location].each do |m|
      define_method(m) do
        self["#{m.to_s}_props".to_sym]
      end
    end

    def base_url url
      self[:base_url] = url
    end

    def list_page url
      self[:list_page] = url
    end

    def all_properties
      values.flat_map { |v|
        v.kind_of?(PropertyContainer) \
          ? v.values \
          : v.kind_of?(Property) \
            ? v \
            : nil
      }.compact
    end
  end
end