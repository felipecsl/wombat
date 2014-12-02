require 'wombat'
require 'rspec'
require 'vcr'
require 'coveralls'

Coveralls.wear!

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end