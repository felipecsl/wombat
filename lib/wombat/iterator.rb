module Wombat
  class Iterator < PropertyContainer
    attr_accessor :selector

    def initialize selector
      @selector = selector
    end    
  end
end