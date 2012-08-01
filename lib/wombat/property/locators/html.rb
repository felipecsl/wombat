#coding: utf-8

module Wombat
  module Property
    module Locators
      class Html < Base
        def locate(context, page = nil)
          node = locate_nodes(context).first
          value = 
            unless node
              nil
            else 
              node.inner_html.strip
            end
          super { value }
        end
      end
    end
  end
end