#coding: utf-8
require 'wombat/node_selector'

module Wombat
  class PropertyLocatorException < Exception; end;

  module PropertyLocator
    include NodeSelector

    SUPPORTED_PROPERTY_TYPES = [:text, :html, :list, :follow]

    def locate(property)
      raise Wombat::PropertyLocatorException.new("Unknown property format #{property.format}: #{property.name}") unless SUPPORTED_PROPERTY_TYPES.include?(property.format)

      props = _locate property
      property.format != :list ? props.first : props
    end

  private
  
    def _locate(property)
      result = select_nodes(property.selector, property.namespaces).to_a

      if property.format == :follow
        result.each { |r| p r }
      end

      result.map! {|r| r.inner_html.strip } if property.format == :html
      result.map {|r| r.kind_of?(String) ? r : r.inner_text }.map(&:strip)
    end
  end
end