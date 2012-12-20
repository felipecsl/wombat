#coding: utf-8

module Wombat
  module Property
    module Locators
      class PropertyGroup < Base
        def locate(context, page = nil)
          super do
            filter_properties(context, page)
          end
        end
      end
    end
  end
end