require 'wombat'
require 'rspec'
require 'rspec-expectations'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end