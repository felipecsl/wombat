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
          # TODO: Verify if another property with same name already exists
          # before overwriting
          property_group = self[property_name] || PropertyGroup.new(property_name)
          self[property_name] = property_group
          property_group.instance_eval(&block)
        else
          it = build_property(property_name, *args, &block)
          self[property_name] = it
          it.instance_eval(&block) unless not block_given? or it.instance_of?(Property)
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

      protected

      def build_property(name, *args, &block)
        if args[1] == :iterator
          Iterator.new(name, args.first)
        elsif args[1] == :follow
          Follower.new(name, args.first)
        else
          Property.new(name, *args, &block)
        end
      end
    end
  end
end