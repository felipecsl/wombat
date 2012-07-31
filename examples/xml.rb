#coding: utf-8
require 'wombat'

class XmlCrawler
  include Wombat::Crawler

  base_url "http://ws.audioscrobbler.com"
  path "/2.0/?method=geo.getevents&location=#{URI.escape('San Francisco')}&api_key=ENV['API_KEY']"
  
  document_format :xml

  title "xpath=//event/title"

  locations 'xpath=//event', :iterator do
    latitude "xpath=./venue/location/geo:point/geo:lat", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
    longitude "xpath=./venue/location/geo:point/geo:long", :text, { 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#' }
  end
end

=begin
pp XmlCrawler.new.crawl

{
	"title"=>"Sinéad O'Connor",
 	"locations"=>[
 		{"latitude"=>"37.807717", "longitude"=>"-122.270059"},
   	{"latitude"=>"37.76213", "longitude"=>"-122.419032"},
   	{"latitude"=>"37.771491", "longitude"=>"-122.413241"},
   	{"latitude"=>"37.776227", "longitude"=>"-122.42044"},
   	{"latitude"=>"37.766588", "longitude"=>"-122.430391"},
   	{"latitude"=>"37.788978", "longitude"=>"-122.40664"},
   	{"latitude"=>"37.769715", "longitude"=>"-122.420427"},
   	{"latitude"=>"37.78832", "longitude"=>"-122.446692"},
   	{"latitude"=>"37.787583", "longitude"=>"-122.421665"},
   	{"latitude"=>"37.776227", "longitude"=>"-122.42044"}
	]
}
=end