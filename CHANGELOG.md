### version 2.5.0 (2016-01-26)

* Updates gem dependencies
* [PR #52](https://github.com/felipecsl/wombat/pull/52) Allow passing the URL as the `Wombat#crawl` argument
* [PR #51](https://github.com/felipecsl/wombat/pull/51) Allow crawler classes inheritance
* [PR #50](https://github.com/felipecsl/wombat/pull/50) Add HTTP methods support (`POST`, `PUT`, `HEAD`, etc)

### version 2.4.0

 * Updates gem dependencies
 * [Adds `user_agent` and `user_agent_alias` config options to `Wombat.configure`](https://github.com/felipecsl/wombat/pull/45)

### version 2.3.0

 * Updates gem dependencies
 * [Adds content-type=text/html header to Mechanize if missing](https://github.com/felipecsl/wombat/pull/40)
 * [Retry page.click on relative links](https://github.com/felipecsl/wombat/pull/32)

### version 2.2.1

 * Adds ability to crawl a prefetched Mechanize page (thanks to @dsjbirch)

### version 2.1.2

 * Added support for hash based property selectors (eg.: `css: 'header'` instead of `'css=.header'`)

### version 2.1.1

 * Updated gem dependencies

### version 2.1.0

 * [Added header properties](https://github.com/felipecsl/wombat/pull/11) (thanks to @kdridi)
 * [Fixed bug in selectors that used XPath functions like `concat`](https://github.com/felipecsl/wombat/pull/10) (thanks to @viniciusdaniel)

### version 2.0.1

 * Added proxy settings configuration (thanks to @phortx)
 * Fixed minor bug in HTML property locator

### version 2.0.0

This version contains some breaking changes (not backwards compatible), most notably to `for_each` that is now specified through the option `:iterator` and nested block parameters that are gone.

 * Added syntactic sugar methods `Wombat.scrape` and `Crawler#scrape` that alias to their respective `crawl` method implementation;
 * Gem internals suffered big refactoring, removed code duplication;
 * DSL syntax simplified for nested properties. Now the nested block takes **no arguments**;
 * DSL syntax changed for iterated properties. Iterators can now be named just like other properties and won't be automatically named as `iterator#{i}` anymore. Specified through the `:iterator` option;
 * `Crawler#list_page` is now called `Crawler#path`;
 * Added new `:follow` property type that crawls links in pages.

### version 1.0.0

 * **Breaking change**: `Metadata#format` renamed to `Metadata#document_format` due to method name clash with [Kernel#format](http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-format)

### version 0.5.0

 * [Fixed a bug on malformed selectors](https://github.com/felipecsl/wombat/commit/e0f4eec20e1e2bb07a1813a1edd019933edeceaa)
 * [Fixed a bug where multiple calls to #crawl would not clean up previously iterated array results and yield repeated results](https://github.com/felipecsl/wombat/commit/40b09a5bf8b9ba08aa51b6f41f706b7c3c4e4252)

### version 0.4.0

 * Added utility method `Wombat.crawl` that eliminates the need to have a ruby class instance to use Wombat. Now you can use just `Wombat.crawl` and start working. The class based format still works as before though.

### version 0.3.1

 * Added the ability to provide a block to Crawler#crawl and override the default crawler properties for a one off run (thanks to @danielnc)
