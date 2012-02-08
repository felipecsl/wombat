module Wombat
  module NodeSelector
    def select_nodes selector, namespaces = nil
      return [selector.to_s] if selector.is_a? Symbol
      return context.xpath selector[6..-1], namespaces if selector.start_with? "xpath="
      return context.css selector[4..-1] if selector.start_with? "css="
      nil
    end
  end
end