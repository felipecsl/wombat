require 'spec_helper'

describe Wombat::Property::Locators::Headers do
  it 'should fetch a list of HTTPResponse headers filtered by a regexp' do
    VCR.use_cassette('headers_selector') do
      regex = "^s.*" # filter headers like: server, status or set-cookie

      result = Wombat.crawl do
        base_url "http://www.github.com"
        path "/"

        headers regex, :headers
      end

      result.should_not be_nil
      result['headers'].size.should >= 1
      result['headers'].should_not be_nil
      result['headers'].each do |key, value|
        key.match(regex).should_not be_nil
      end
    end
  end
end