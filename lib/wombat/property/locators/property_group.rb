#coding: utf-8

module Wombat
  module Property
    module Locators
      class PropertyGroup < Base
        def locate(context)
          super do
            Hash.new.tap do |h|
              @property.values
                .select { |v| v.is_a?(Wombat::DSL::Property) || v.is_a?(Wombat::DSL::PropertyGroup) }
                .map { |p| Factory.locator_for(p).locate(context) }
                .map { |p| h.merge! p }
            end
          end
        end
      end
    end
  end
end