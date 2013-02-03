# Wombat

[![CI Build Status](https://secure.travis-ci.org/felipecsl/wombat.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/felipecsl/wombat.png?travis)][gemnasium] [![Code Climate](https://codeclimate.com/github/felipecsl/wombat.png)][codeclimate]

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
require 'wombat'

Wombat.crawl do
  base_url "http://www.github.com"
  path "/"

  headline "xpath=//h1"
  subheading "css=p.subheading"

  what_is "css=.teaser h3", :list

  links do
    explore 'xpath=//*[@id="wrapper"]/div[1]/div/ul/li[1]/a' do |e|
      e.gsub(/Explore/, "Love")
    end

    search 'css=.search'
    features 'css=.features'
    blog 'css=.blog'
  end
end
```

###### The code above is gonna return the following hash:

```ruby
{
  "headline"=>"Build software better, together.",
  "subheading"=> "Powerful collaboration, review, and code management for open source and private development projects.",
  "what_is"=> [
    "Great collaboration starts with communication.",
    "Manage and contribute from all your devices.",
    "The world’s largest open source community."
  ],
  "links"=> {
    "explore"=>"Love GitHub",
    "search"=>"Search",
    "features"=>"Features",
    "blog"=>"Blog"
  }
}
```

### This is just a sneak peek of what Wombat can do. For the complete documentation, please check the [project Wiki](http://github.com/felipecsl/wombat/wiki).
### [API Documentation](http://rubydoc.info/gems/wombat/2.0.0/frames)
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
 * [List of all contributors](https://github.com/felipecsl/wombat/wiki/Contributors)

## Copyright

Copyright (c) 2012 Felipe Lima. See LICENSE.txt for further details.

