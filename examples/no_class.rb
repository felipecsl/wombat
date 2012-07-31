#coding: utf-8
require 'wombat'

data = Wombat.crawl do
  base_url "http://www.github.com"
  path "/"

  headline "xpath=//h1"
  what_is "css=.column.secondary p", :html

  explore "xpath=//ul/li[2]/a" do |e|
    e.gsub(/Explore/, "LOVE")
  end

  benefits do
    team_mgmt "css=.column.leftmost h3"
    code_review "css=.column.leftmid h3"
    hosting "css=.column.rightmid h3"
    collaboration "css=.column.rightmost h3"

    links do
      team_mgmt "xpath=//div[@class='column leftmost']//a/@href"
    end
  end
end

=begin
pp data
{
  "headline"=>"1,900,094\n        people hosting over\n        3,371,168\n        repositories",
  "what_is"=>"GitHub is the best way to collaborate with others.  Fork, send pull requests and manage all your <strong>public</strong> and <strong>private</strong> git repositories.",
  "explore"=>"LOVE GitHub",
  "benefits"=> {
    "team_mgmt"=>"Team management",
    "code_review"=>"Code review",
    "hosting"=>"Reliable code hosting",
    "collaboration"=>"Open source collaboration",
    "links"=>{"team_mgmt"=>"/features/projects/collaboration"}
  }
}
=end