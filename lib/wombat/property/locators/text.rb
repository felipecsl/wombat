#coding: utf-8

module Wombat
  module Property
    module Locators
      class Text < Base
        def locate(context, page = nil)
          node = locate_nodes(context)
          node = node.first unless node.is_a?(String)

          value = 
            unless node
              nil
            else 
              node.is_a?(String) ? node.strip : node.inner_text.strip
            end
            
          super { value }
        end
      end
    end
  end
end