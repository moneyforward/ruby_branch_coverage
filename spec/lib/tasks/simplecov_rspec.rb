require 'rake'
require 'spec_helper'
require 'fileutils'

describe 'simplecov:report_coverage' do

  let(:task_path) { 'lib/tasks/simplecov' }
  let(:task_name) { 'simplecov:report_coverage' }

  before do
    FileUtils.rm_rf('spec/dummy/coverage')
    FileUtils.rm_rf('spec/dummy/coverage_results')
    FileUtils.cd('spec/dummy')
    FileUtils.mkdir('coverage_results')
  end

  after do
    FileUtils.cd('../../')
  end

  context 'when tests are executed in sections' do
    it 'creates a .resultset.json file' do
      `bundle exec rspec spec/requests`
      FileUtils.cp_r('coverage/.resultset.json', 'coverage_results/.resultset-0.json')
      `bundle exec rspec spec/views`
      FileUtils.cp_r('coverage/.resultset.json', 'coverage_results/.resultset-1.json')
      Rake::Task['simplecov:report_coverage'].invoke('2')
      expect(File.exist?('spec/dummy/coverage/.resultset.json')).to be_truthy
      expect(File.exist?('spec/dummy/coverage/branch-coverage.xml')).to be_truthy
    end
  end

  context 'when tests are not executed in sections' do
    it 'creates a .resultset.json file' do
      `bundle exec rspec`
      FileUtils.cp_r('coverage/.resultset.json', 'coverage_results/.resultset-0.json')
      Rake::Task['simplecov:report_coverage'].invoke
      expect(File.exist?('spec/dummy/coverage/.resultset.json')).to be_truthy
      expect(File.exist?('spec/dummy/coverage/branch-coverage.xml')).to be_truthy
    end
  end
end
