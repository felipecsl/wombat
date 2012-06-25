require 'spec_helper'

describe Wombat do
	it 'should provide syntactic sugar method Wombat.crawl' do
		Wombat.should respond_to(:crawl)
	end

	it 'should accept regular properties (non-selectors)' do
		VCR.use_cassette('broken_selector') do
			lambda { 
				Wombat.crawl do
					base_url "http://www.github.com"
		  		list_page "/"

		  		source :obaoba
			    description 'Oba Oba'
			    website 'http://obaoba.com.br'
				end
			}.should_not raise_error
		end
	end
end