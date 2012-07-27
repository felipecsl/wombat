#coding: utf-8

module Wombat
  module DSL
    class PropertyContainer < Hash
      
      def method_missing(method, *args, &block)
        property_name = method.to_s

        if args.empty? && block
          self[property_name] = PropertyContainer.new unless self[property_name]
          block.call self[property_name]
        else
          unless args[1] == :iterator
            # TODO: Need to decide whether to instantiate Property or IteratorProperty here
            self[property_name] = Property.new(
              name: property_name,
              selector: args.first,
              format: args[1],
              namespaces: args[2],
              callback: block)
          else 
            it = Iterator.new(property_name, selector)
            self[property_name] = it
            it.instance_eval(&block) if block
          end
        end      
      end

      def to_ary
      end

      def parse(context)
        values.each do |property_or_container|
          if property_or_container.is_a?(Property)
            property = property_or_container
            factory = Locators::Factory.locator_for(property, @context)
            property.parse locator
          elsif property_or_container.is_a?(PropertyContainer)
            container = property_or_container
            container.parse @context
          else 
            raise "Unknown property"
          end
        end
      end

      def flatten(depth = nil)
        properties = Hash.new.tap do |h|
          keys.map do |k|
            val = self[k]
            if val.is_a?(PropertyContainer) || val.is_a?(Property)
              h[k] = val.flatten depth
            end
          end
        end

        iters = iterators.reduce({}) do |memo, i| 
          memo.merge("iterator#{iterators.index(i)}" => i.flatten)
        end

        properties.merge iters
      end
    end
  end
end