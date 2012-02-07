#coding: utf-8

module Wombat
  module PropertyLocator
    def locate properties
      properties.each do |p|
        p.result = locate_property(p).first
      end
    end

    private 
    def locate_property property
      result = locate_selector(property.selector, property.namespaces)
      result.map! {|r| r.inner_html.strip } if property.format == :html
      result.map {|r| r.kind_of?(String) ? r : r.inner_text }.map(&:strip)
    end

    def locate_selector selector, namespaces = nil
      return [selector.to_s] if selector.is_a? Symbol
      return context.xpath selector[6..-1], namespaces if selector.start_with? "xpath="
      return context.css selector[4..-1] if selector.start_with? "css="
      nil
    end
  end
end