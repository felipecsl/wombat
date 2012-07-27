module Wombat
  module DSL
    class IteratorProperty < Property
      def initialize(options)
        @result = []
        super(options)
      end

      def parse(locator)
        result = locator.locate
        self.result << callback ? callback.call(result) : result
      end
    end
  end
end