require 'spec_helper'

describe Wombat::DSL::Iterator do
  let(:it) { Wombat::DSL::Iterator.new "it_selector", "blaj" }

   context 'reset' do
    it 'should clean up properties results' do
      it.prop_1 'some_selector'
      it['prop_1'].result = [1, 2]
      it.reset
      it['prop_1'].result.should be_nil
    end
  end
end