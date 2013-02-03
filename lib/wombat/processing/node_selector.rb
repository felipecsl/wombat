module Wombat
  module Processing
    module NodeSelector
      def select_nodes(selector, namespaces = nil)
        return [selector.to_s] if selector.is_a? Symbol

        if selector.is_a? String
          return @context.xpath selector[6..-1], namespaces if selector.start_with? "xpath="
          return @context.css selector[4..-1] if selector.start_with? "css="
        end

        if selector.is_a? Hash
          method = selector.flatten.first
          selector = selector.flatten.last
          return @context.xpath selector, namespaces if method == :xpath
          return @context.css selector if method == :css
        end

        [selector]
      end
    end
  end
end