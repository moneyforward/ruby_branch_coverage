# frozen_string_literal: true

# simplecov がtest環境のときのみ読み込まれるため、
# このRakeタスクもtestのときのみ読み込む
require 'ruby_branch_cover'
require 'simplecov'
require 'simplecov_json_formatter'
namespace :simplecov do
  desc 'Merge coverage results'
  task :report_coverage, [:parallelism] => [:environment] do |_t, args|
    SimpleCov.start 'rails' do
      enable_coverage :branch

      add_filter '/spec/'
      add_filter '/config/'
      add_filter '/db/'
      add_filter '/vendor/'

      add_group 'Decorators', 'app/decorators'
      add_group 'Forms', 'app/forms'
      add_group 'Services', 'app/services'
      add_group 'ViewObjects', 'app/view_objects'
      add_group 'Batches', 'app/batches'

      merge_timeout 3600
    end
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
