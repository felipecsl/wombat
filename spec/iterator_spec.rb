require 'spec_helper'

describe Wombat::Iterator do
	let(:it) { Wombat::Iterator.new "it_selector" }

   context 'parse' do
	   it 'should iterate in for_each properties' do
	    it.prop_1 "some_selector"
	    it.prop_2 "another_selector"
	    
	    it['prop_1'].should_receive(:result).twice.and_return([])
	    it['prop_2'].should_receive(:result).twice.and_return([])
	    
	    parser = double :parser
	    parser.should_receive(:locate).with(it['prop_1']).twice
	    parser.should_receive(:locate).with(it['prop_2']).twice

	    it.parse { |p| parser.locate p }
	    it.parse { |p| parser.locate p }
	  end

	  it 'should raise if no block given' do
	  	expect{
	  		it.parse
  		}.to raise_error(ArgumentError)
	  end
	end

  it 'should flatten properties to plain hash format' do
  	it.prop_1 "some_selector"
    it.prop_2 "another_selector"

    it.parse {|p| }
    it.parse {|p| }
    it['prop_1'].result = ['result 1', 'result 2']
    it['prop_2'].result = ['result 3', 'result 4']

    it.flatten.should == [
    	{ "prop_1" => "result 1", "prop_2" => "result 3" },
    	{ "prop_1" => "result 2", "prop_2" => "result 4" }
    ]
  end
end