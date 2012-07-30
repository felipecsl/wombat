#coding: utf-8

module Wombat
  module DSL
    class PropertyContainer < Hash
      attr_accessor :name

      def initialize(name = nil)
        @name = name
      end

      def method_missing(method, *args, &block)
        property_name = method.to_s

        if args.empty? && block
          self[property_name] = PropertyContainer.new(property_name) unless self[property_name]
          block.call self[property_name]
        else
          unless args[1] == :iterator
            self[property_name] = Property.new(
              name: property_name,
              selector: args.first,
              format: args[1],
              namespaces: args[2],
              callback: block)
          else
            it = Iterator.new(property_name, args.first)
            self[property_name] = it
            it.instance_eval(&block) if block
          end
        end      
      end

      def to_ary
      end

      # So that Property::Locators::Iterator can identify this class
      # as an iterator property.
      # TODO: Called by NodeSelector. Fix this
      def format
        :container
      end

      def namespaces
        # TODO: Called by NodeSelector. Fix this
        nil
      end

      def all_properties
        values.flat_map { |v|
          if v.kind_of? PropertyContainer
            v.all_properties
          elsif v.kind_of? Property
            v
          else
            nil
          end
        }.compact
      end
    end
  end
end