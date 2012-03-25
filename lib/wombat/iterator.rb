module Wombat
  class Iterator < PropertyContainer
    attr_accessor :selector

    def initialize(selector)
      @selector = selector
      super()
    end

    def parse
    	raise ArgumentError.new('Must provide a block to locate property values') unless block_given?

    	all_properties.each do |p|
        p.result ||= []
        result = yield p
        if result
          result = p.callback ? p.callback.call(result) : result
          p.result << result
        end
      end
    end

    def flatten(depth = nil)
    	# determine the iterator length by the biggest property array that we have
    	length = all_properties.map(&:result).sort { |a| a.length }.last.size

    	Array.new.tap do |a|
		  	length.times do |i|
		  		a << super(i)
		  	end
		  end
	  end
  end
end