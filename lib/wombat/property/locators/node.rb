#coding: utf-8

module Wombat
  module Property
    module Locators
      class Node < Base
        def locate(context, page = nil)
          node = locate_nodes(context)
          node = node.first unless node.is_a?(Nokogiri::XML::Node)
          super { node }
        end
      end
    end
  end
end

