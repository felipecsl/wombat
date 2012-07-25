module Wombat
  # Each iterator property keeps an array
  # with the results of each iteration pass.
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

    def reset
      all_properties.each { |p| p.reset }
    end

    def flatten(depth = nil)
    	# Determine the iterator array length by the biggest property result array that we have
    	length = all_properties.map(&:result).sort { |a| a.length }.last.size

    	# Allocate an array and fall back to default
      # flatten implementation to fill the resulting hash
      # based on the current property depth.
      Array.new.tap do |a|
		  	length.times do |i|
		  		a << super(i)
		  	end
		  end
	  end
  end
end