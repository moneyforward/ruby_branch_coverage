# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

namespace :simplecov do
  desc 'Merge coverage results'
  task :report_coverage, [:parallelism] => [:environment] do |_t, args|
    filters = %w[spec config db vendor]
    groups = %w[models controllers services decorators forms view_objects batches graphql jobs]

    SimpleCov.start 'rails' do
      enable_coverage :branch

      filters.each { |filter| add_filter "/#{filter}/" }
      groups.each { |group| add_group group.capitalize, "app/#{group}" }

      merge_timeout 3600
    end
    SimpleCov.collate Dir['./coverage_results/.resultset*.json'], 'rails' do
      formatter SimpleCov::Formatter::MultiFormatter.new([
                                                           SimpleCov::Formatter::HTMLFormatter,
                                                           SimpleCov::Formatter::JSONFormatter
                                                         ])
    end
    ruby_branch = RubyBranchCoverage.new
    ruby_branch.read_json_and_getxml('coverage/.resultset.json', args[:parallelism].to_i)
  end
end
