module EventCrawler
  class Property
    attr_accessor :selector

    def initialize selector
      @selector = selector
    end
  end
end