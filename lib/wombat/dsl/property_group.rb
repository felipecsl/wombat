#coding: utf-8

module Wombat
  module DSL
    class PropertyGroup < Hash
      attr_accessor :wombat_property_name

      def initialize(name = nil)
        @wombat_property_name = name
      end

      def method_missing(method, *args, &block)
        property_name = method.to_s

        if args.empty? && block
          self[property_name] = PropertyGroup.new(property_name) unless self[property_name]
          block.call self[property_name]
        else
          unless args[1] == :iterator
            self[property_name] = Property.new(property_name, *args, &block)
          else
            it = Iterator.new(property_name, args.first)
            self[property_name] = it
            it.instance_eval(&block) if block
          end
        end      
      end

      def to_ary
      end

      def wombat_property_format
        :container
      end

      def wombat_property_namespaces
        nil
      end
    end
  end
end