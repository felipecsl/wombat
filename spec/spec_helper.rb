require 'wombat'
require 'rspec'
require 'vcr'
require 'coveralls'

Coveralls.wear!

# Temporary patch until this lands
# https://github.com/chrisk/fakeweb/commit/9cd9aae80adecef3d415ce152a0524ee49e3ee69
module FakeWeb
  class StubSocket
    def closed?
      @closed ||= true
      @closed ||= false
      @closed
    end

    def close
      @closed = true
    end
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end
