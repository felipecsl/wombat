#coding: utf-8
require "wombat"

data = Wombat.crawl do
  base_url "http://www.github.com"
  path "/"

  headline xpath: "//h1"
  subheading css: "p.subheading"

  links({xpath: '//*[@class="wrapper"]/div[1]/div//ul/li/a'}, :node_list) do |data|
    Hash[data.map{ |link| [ link.text.downcase, link.attr("href") ] }]
  end
end

pp data

=begin
pp data
{
 "headline"=>"Build software better, together.",
 "subheading"=>
  "Powerful collaboration, review, and code management for open source and private development projects.",
 "what_is"=>
  ["Great collaboration starts with communication.",
   "Manage and contribute from all your devices.",
   "The world’s largest open source community."],
 "links"=>
  {"explore"=>"Love GitHub",
   "search"=>"Search",
   "features"=>"Features",
   "blog"=>"Blog"
  }
}
=end

