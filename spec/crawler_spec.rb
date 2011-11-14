require 'spec_helper'

describe EventCrawler::Crawler do
  before(:each) do
    @crawler = Class.new
    @crawler.send(:include, EventCrawler::Crawler)
  end

  it 'should call the block provided to event method' do
    block_called = false
    @crawler.event do
      block_called = true
    end 
    block_called.should be_true
  end

  it 'should call the block provided to venue method' do
    block_called = false
    @crawler.venue do
      block_called = true
    end 
    block_called.should be_true
  end

  it 'should call the block provided to location method' do
    block_called = false
    @crawler.location do
      block_called = true
    end 
    block_called.should be_true
  end

  it 'should call the block provided to details page method' do
    block_called = false
    @crawler.with_details_page do
      block_called = true
    end 
    block_called.should be_true
  end
end