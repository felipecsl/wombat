#coding: utf-8

module Wombat
  class PropertyContainer < Hash
    attr_accessor :iterators

    def initialize
      @iterators = []
    end

    def method_missing method, *args, &block
      if args.empty? && block
        self["#{method.to_s}"] = PropertyContainer.new unless self["#{method.to_s}"]
        block.call(self["#{method.to_s}"])
      else
        self[method.to_s] = Property.new(
          name: method.to_s,
          selector: args.first,
          format: args[1],
          namespaces: args[2],
          callback: block)
      end      
    end

    def to_ary
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

    def flatten
      Hash.new.tap do |h|
        keys.map do |k|
          if self[k].kind_of?(PropertyContainer) || self[k].kind_of?(Property)
            h[k] = self[k].flatten
          end
        end
      end.merge(iterators.inject({}) {|memo, i| memo.merge(i.flatten) })
    end

    def for_each selector
      Iterator.new(selector).tap do |i|
        iterators << i
      end
    end
  end
end