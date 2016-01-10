# coding: utf-8
require 'spec_helper'

describe 'crawler base and one derived class' do
  class A
    include Wombat::Crawler
    title 'xpath=//head/title'
  end

  class B < A
    base_url "http://www.terra.com.br"
    path "/portal"
    search "css=.btn-search"
  end

  it 'extracts properties defined in the base class ' do
    VCR.use_cassette('basic_crawler_page') do
      b = B.new
      data = b.crawl
      expect(data).to have_key('title')
      expect(data).to have_key('search')
    end
  end
end

describe 'two derived classes' do
  class D
    include Wombat::Crawler
    title 'xpath=//head/title'
  end

  class E < D
    base_url "http://www.terra.com.br"
    path "/portal"
    search "css=.btn-search"
  end

  class F < D
    title 'xpath=//broken/badly'
    base_url "https://www.github.com"
    path "/"
  end


  it 'second derived class does not overwrite base class properties' do
    VCR.use_cassette('basic_crawler_page') do
      e = E.new
      data = e.crawl
      expect(data).to have_key('title')
      expect(data).to have_key('search')
      expect(data['title']).to eq('Terra - Notícias, vídeos, esportes, economia, diversão, música, moda, fotolog, blog, chat')
    end
  end

  it 'first derived class does not overwrite base class properties' do
    VCR.use_cassette('follow_links') do
      f = F.new
      data = f.crawl
      expect(data).to have_key('title')
      expect(data['title']).to be_nil
    end
  end
end
