require 'spec_helper'

describe Wombat do
	it 'should provide syntactic sugar method Wombat.crawl' do
		Wombat.should respond_to(:crawl)
	end
end