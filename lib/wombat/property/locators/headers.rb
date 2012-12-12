#coding: utf-8

module Wombat
  module Property
    module Locators
      class Headers < Base
        def locate(context, page = nil)
          super do
            context.headers.select do |k, v|
              k.to_s.match(@property.wombat_property_selector)
            end
          end
        end
      end
    end
  end
end