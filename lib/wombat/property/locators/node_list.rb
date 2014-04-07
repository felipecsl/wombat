#coding: utf-8

module Wombat
  module Property
    module Locators
      class NodeList < Base
        def locate(context, page = nil)
          super { locate_nodes(context).to_a }
        end
      end
    end
  end
end
