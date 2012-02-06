# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'jeweler'
require 'rspec/core/rake_task'
require 'yard'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "wombat"
  gem.homepage = "http://github.com/felipecsl/wombat"
  gem.license = "MIT"
  gem.summary = %Q{Ruby DSL to crawl web pages}
  gem.description = %Q{Generic Web crawler with a DSL that parses structured data from web pages}
  gem.email = "felipe.lima@gmail.com"
  gem.authors = ["Felipe Lima"]
  # dependencies defined in Gemfile
end

Jeweler::RubygemsDotOrgTasks.new

RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

YARD::Rake::YardocTask.new