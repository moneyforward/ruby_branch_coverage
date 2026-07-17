# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

namespace :simplecov do
  desc 'Merge coverage results'
  task :report_coverage, %i[parallelism processors] => [:environment] do |_t, args|
    SimpleCov.start 'rails' do
      enable_coverage :branch

      skip '/spec/'
      skip '/config/'
      skip '/db/'
      skip '/vendor/'

      group 'Decorators', 'app/decorators'
      group 'Forms', 'app/forms'
      group 'Services', 'app/services'
      group 'ViewObjects', 'app/view_objects'
      group 'Batches', 'app/batches'

      merge_timeout 3600
    end

    SimpleCov.collate Dir['./coverage_results/.resultset*.json'], 'rails' do
      formatter SimpleCov::Formatter::MultiFormatter.new([
                                                           SimpleCov::Formatter::HTMLFormatter,
                                                           SimpleCov::Formatter::JSONFormatter
                                                         ])
    end
    ruby_branch = RubyBranchCoverage.new
    ruby_branch.read_json_and_getxml('coverage/.resultset.json', args[:parallelism].to_i, args[:processors].to_i)
  end
end
