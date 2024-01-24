#coding: utf-8

module Wombat
  module Property
    module Locators
      class Url < Base
        def locate(context, page = nil)
          value = context.url

          super { value }
        end
      end
    end
  end
end
