require 'spec_helper'

describe EventCrawler::Parser do
  before(:each) do
    @parser = EventCrawler::Parser.new
    @metadata = EventCrawler::Metadata.new
  end

  xit 'should send property object to locator' do
    @metadata.event_props.description "xpath=/data/location", :html
    @metadata.venue_props.name "css=.venue-name"
    @metadata.custom_field "xpath=/another/place", :text do |field|
      field[0..2]
    end

    @parser.parse @metadata
  end

  xit 'should call the metadata callback if present' do
    block_called = false
    @metadata.event_props.name "xpath=/selector", :html do |t|
      block_called = true
    end
    @parser.parse @metadata
    block_called.should be_true
  end
end
