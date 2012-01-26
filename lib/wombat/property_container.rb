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
  end
end