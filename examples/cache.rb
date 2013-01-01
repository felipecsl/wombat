#coding: utf-8
require 'wombat'

class CachedCrawler
  include Wombat::Crawler

  base_url "http://www.rubygems.org"
  path "/"
  should_cache :true

  gems do
    new "css=#new_gems li", :list
    most_downloaded "css=#most_downloaded li", :list
    just_updated "css=#just_updated li", :list
  end
end

=begin
pp CachedCrawler.new.crawl
=end
