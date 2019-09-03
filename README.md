# Wombat

[![Gem Version](https://badge.fury.io/rb/wombat.svg)](https://badge.fury.io/rb/wombat)
[![CI Build Status](https://secure.travis-ci.org/felipecsl/wombat.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/felipecsl/wombat.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/felipecsl/wombat.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/felipecsl/wombat/badge.png?branch=master)][coveralls]
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Ffelipecsl%2Fwombat.svg?type=shield)][fossa]

[rubygems]: http://rubygems.org/gems/wombat
[travis]: http://travis-ci.org/felipecsl/wombat
[gemnasium]: https://gemnasium.com/felipecsl/wombat
[codeclimate]: https://codeclimate.com/github/felipecsl/wombat
[coveralls]: https://coveralls.io/r/felipecsl/wombat?branch=master
[fossa]: https://app.fossa.io/projects/git%2Bgithub.com%2Ffelipecsl%2Fwombat?ref=badge_shield

Web scraper with an elegant DSL that parses structured data from web pages.

## Usage:

`gem install wombat`

## Scraping a page:

The simplest way to use Wombat is by calling `Wombat.crawl` and passing it a block:

```ruby
require 'wombat'

Wombat.crawl do
  base_url "https://www.github.com"
  path "/"

  headline xpath: "//h1"
  subheading css: "p.alt-lead"

  what_is({ css: ".one-fourth h4" }, :list)

  links do
    explore xpath: '/html/body/header/div/div/nav[1]/a[4]' do |e|
      e.gsub(/Explore/, "Love")
    end

    features css: '.nav-item-opensource'
    business css: '.nav-item-business'
  end
end
```

###### The code above is gonna return the following hash:

```ruby
{
  "headline"=>"How people build software",
  "subheading"=>"Millions of developers use GitHub to build personal projects, support their businesses, and work together on open source technologies.",
  "what_is"=>[
    "For everything you build",
    "A better way to work",
    "Millions of projects",
    "One platform, from start to finish"
  ],
  "links"=>{
    "explore"=>"Love",
    "features"=>"Open source",
    "business"=>"Business"
  }
}
```

### This is just a sneak peek of what Wombat can do. For the complete documentation, please check the links below:

### [Wiki](http://github.com/felipecsl/wombat/wiki)
### [API Documentation](https://rubydoc.info/gems/wombat)
### [Changelog](https://github.com/felipecsl/wombat/blob/master/CHANGELOG.md)

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
 * [List of all contributors](https://github.com/felipecsl/wombat/graphs/contributors)

## Copyright

Copyright (c) 2019 Felipe Lima. See LICENSE.txt for further details.


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Ffelipecsl%2Fwombat.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Ffelipecsl%2Fwombat?ref=badge_large)
