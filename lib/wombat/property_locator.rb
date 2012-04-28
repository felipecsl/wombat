#coding: utf-8
require 'wombat/node_selector'

module Wombat
  module PropertyLocator
    include NodeSelector

    def locate(property)
      props = _locate property
      property.format != :list ? props.first : props
    end

    private
    def _locate(property)
      result = select_nodes(property.selector, property.namespaces).to_a
      result.map! {|r| r.inner_html.strip } if property.format == :html
      result.map {|r| r.kind_of?(String) ? r : r.inner_text }.map(&:strip)
    end
  end
end