# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

namespace :simplecov do
  desc 'Merge coverage results'
  task :report_coverage, [:parallelism] => [:environment] do |_t, args|
    SimpleCov.collate Dir['./coverage_results/.resultset*.json'], 'rails' do
      formatter SimpleCov::Formatter::MultiFormatter.new([
                                                           SimpleCov::Formatter::HTMLFormatter,
                                                           SimpleCov::Formatter::JSONFormatter
                                                         ])
    end
    ruby_branch = RubyBranchCover.new
    ruby_branch.read_json_and_getxml('coverage/.resultset.json', args[:parallelism].to_i)
  end
end
