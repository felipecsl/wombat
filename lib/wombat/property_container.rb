#coding: utf-8

module Wombat
  class PropertyContainer < Hash
    def add_property property
      self[property.name] = property
    end

    def get_property name
      self[name]
    end

    def method_missing method, *args, &block
      self[method.to_s] = Property.new(
        name: method.to_s,
        selector: args.first,
        format: args[1],
        namespaces: args[2],
        callback: block)
    end

    def all_properties
      values.flat_map { |v|
        v.kind_of?(PropertyContainer) \
          ? v.values \
          : v.kind_of?(Property) \
            ? v \
            : nil
      }.compact
    end

    def flatten
      Hash.new.tap do |h|
        keys.map do |k|
          if self[k].kind_of?(PropertyContainer)
            h[k] = self[k].flatten
          elsif self[k].kind_of?(Property)
            h[k] = self[k].result
          end
        end
      end
    end
  end
end