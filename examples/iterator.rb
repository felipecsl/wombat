#coding: utf-8
require 'wombat'

class IteratorCrawler
  include Wombat::Crawler

  base_url "https://www.github.com"
  path "/explore"

  repos "css=ol.ranked-repositories>li", :iterator do
    repo 'css=h3'
    description 'css=p.description'
  end
end

=begin
p IteratorCrawler.new.crawl
{"repos"=>
  [
  	{	
  		"repo"=>"bernii / gauge.js",
    	"description"=>"100% native and cool looking JavaScript gauge"
  	},
   	{
   		"repo"=>"ZeitOnline / briefkasten",
    	"description"=>"a reasonably secure web application for submitting content anonymously"
  	},
   	{
   		"repo"=>"nothingmagical / cheddar-ios", 
   		"description"=>"Cheddar for iOS"
 		},
   	{
   		"repo"=>"nathanmarz / storm-mesos",
    	"description"=>"Run Storm on top of the Mesos cluster resource manager"
  	},
   	{
   		"repo"=>"Netflix / SimianArmy",
    	"description"=>"Tools for keeping your cloud operating in top form. Chaos Monkey is a resiliency tool that helps ..."
    },
   	{
   		"repo"=>nil, 
   		"description"=>nil
   	}
	]
}
=end