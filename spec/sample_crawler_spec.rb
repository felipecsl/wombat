require 'spec_helper'
require 'helpers/sample_crawler'

describe SampleCrawler do
  before(:each) do
    @sample_crawler = SampleCrawler.new
  end

  it 'should correctly assign event metadata' do
    @sample_crawler.should_receive(:parse) do |args|
      args['event_group'].wombat_property_selector.should eq "css=div.title-agenda"
      it = args['event_group']
      expect(it["event"]["title"].wombat_property_selector).to eq("xpath=.")
      expect(it["event"]["date"].wombat_property_selector).to(
        eq("xpath=//div[@class='scrollable-items']/div[@class='s-item active']//a"))
      expect(it["event"]["type"].wombat_property_selector).to eq("xpath=.type")
      expect(it["venue"]["name"].wombat_property_selector).to eq("xpath=.")

      args[:base_url].should eq 'http://www.obaoba.com.br'
      args[:path].should eq '/porto-alegre/agenda'
    end

    @sample_crawler.crawl
  end
end
