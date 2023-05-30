require "bundler/setup"

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

require "rake/testtask"

Rake.add_rakelib 'lib/tasks'

# add rspec rake task
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec
