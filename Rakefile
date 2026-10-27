# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'juwelier'
require 'rspec/core/rake_task'
require 'yard'

module TempFixForRakeLastComment
  def last_comment
    last_description
  end
end
Rake::Application.send :include, TempFixForRakeLastComment

# juwelier tags a release with a plain `git tag vX.Y.Z` (no message). With
# tag.gpgSign enabled globally, git turns that into an annotated tag and opens
# an editor for the tag message, which stalls `rake release`. Tags here are
# lightweight, so keep them that way for git commands spawned by rake.
ENV['GIT_CONFIG_COUNT'] = '1'
ENV['GIT_CONFIG_KEY_0'] = 'tag.gpgSign'
ENV['GIT_CONFIG_VALUE_0'] = 'false'

Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "wombat"
  gem.homepage = "http://felipecsl.github.com/wombat"
  gem.license = "MIT"
  gem.summary = %Q{Ruby DSL to scrape web pages}
  gem.description = %Q{Generic Web crawler with a DSL that parses structured data from web pages}
  gem.email = "felipe.lima@gmail.com"
  gem.authors = ["Felipe Lima"]
  gem.required_ruby_version = ">= 1.9"
  # dependencies defined in Gemfile
end

Juwelier::RubygemsDotOrgTasks.new

RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

YARD::Rake::YardocTask.new
