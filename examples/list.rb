#coding: utf-8
require 'wombat'

class ListCrawler
  include Wombat::Crawler

  base_url "http://www.rubygems.org"
  path "/"

  gems do
    new "css=#new_gems li", :list
    most_downloaded "css=#most_downloaded li", :list
    just_updated "css=#just_updated li", :list
  end
end

=begin
pp ListCrawler.new.crawl
{
  "gems"=>{
    "new"=>[
      "buffer (0.0.1)",
       "resque-telework (0.2.0)",
      "my_string_extend_lyk (0.0.1)",
      "specr (0.0.1)",
      "array-frequency (1.0.0)"
    ],
     "most_downloaded"=> [
       "rake-0.9.2.2 (7,128)",
       "mime-types-1.19 (5,331)",
       "tilt-1.3.3 (5,146)",
       "rack-1.4.1 (5,124)",
       "multi_json-1.3.6 (5,093)"
     ],
     "just_updated"=>[
       "wombat (2.0.0)",
       "pdf-reader-turtletext (0.2.1)",
       "minitest-reporters (0.10.0)",
       "cloudprint (0.1.3)",
       "greenletters (0.2.0)"
    ]
  }
}
=end
