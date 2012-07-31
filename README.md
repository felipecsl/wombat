# Wombat

[![CI Build Status](https://secure.travis-ci.org/felipecsl/wombat.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/felipecsl/wombat.png?travis)][gemnasium] [![Code Climate](https://codeclimate.com/badge.png)][codeclimate]

[travis]: http://travis-ci.org/felipecsl/wombat
[gemnasium]: https://gemnasium.com/felipecsl/wombat
[codeclimate]: https://codeclimate.com/github/felipecsl/wombat

Web scraper with an elegant DSL that parses structured data from web pages.

## Usage:

``gem install wombat``

Obs: Requires ruby 1.9

## Scraping a page:

The simplest way to use Wombat is by calling ``Wombat.crawl`` and passing it a block:

```ruby

# => github_scraper.rb

#coding: utf-8
require 'wombat'

Wombat.crawl do
  base_url "http://www.github.com"
  path "/"

  headline "xpath=//h1"

  what_is "css=.column.secondary p", :html

  explore "xpath=//ul/li[2]/a" do |e|
    e.gsub(/Explore/, "LOVE")
  end

  benefits do
    first_benefit "css=.column.leftmost h3"
    second_benefir "css=.column.leftmid h3"
    third_benefit "css=.column.rightmid h3"
    fourth_benefit "css=.column.rightmost h3"
  end
end
```

###### The code above is gonna return the following hash: 

```ruby
{
  "headline" => "1,316,633 people hosting over 3,951,378 git repositories", 
  "what_is" => "GitHub is the best way to collaborate with others.  Fork, send pull requests and manage all your <strong>public</strong> and <strong>private</strong> git repositories.",
  "explore" => "LOVE GitHub",
  "benefits" => {
    "first_benefit"  => "Team management", 
    "second_benefit" => "Code review", 
    "third_benefit"  => "Reliable code hosting", 
    "fourth_benefit" => "Open source collaboration"
  }
}
```

### This is just a sneak peek of what Wombat can do. For the complete documentation, please check the [project Wiki](http://github.com/felipecsl/wombat/wiki).
### [API Documentation](http://rubydoc.info/gems/wombat/1.0.0/frames)
### [Changelog](https://github.com/felipecsl/wombat/wiki/Changelog)


## Contributing to Wombat
 
 * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
 * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
 * Fork the project
 * Start a feature/bugfix branch
 * Commit and push until you are happy with your contribution
 * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
 * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Contributors

 * Felipe Lima ([@felipecsl](https://github.com/felipecsl))
 * Daniel Naves de Carvalho ([@danielnc](https://github.com/danielnc))
 * [@sigi](https://github.com/sigi)

## Copyright

Copyright (c) 2012 Felipe Lima. See LICENSE.txt for further details.

