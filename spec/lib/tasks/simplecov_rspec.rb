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

  context 'when separate' do
    it 'creates a .resultset.json file' do
      `bundle exec rspec spec/requests && cp -R coverage/.resultset.json coverage_results/.resultset-0.json && bundle exec rspec spec/views && cp -R coverage/.resultset.json coverage_results/.resultset-1.json && bundle exec rails simplecov:report_coverage[2]`
      expect(File.exist?('spec/dummy/coverage/.resultset.json')).to be_truthy
      expect(File.exist?('spec/dummy/coverage/branch-coverage.xml')).to be_truthy
    end
  end

  context 'not separate' do
    it 'creates a .resultset.json file' do
      `bundle exec rspec && cp -R coverage/.resultset.json coverage_results/.resultset-0.json && bundle exec rails simplecov:report_coverage`
      expect(File.exist?('spec/dummy/coverage/.resultset.json')).to be_truthy
      expect(File.exist?('spec/dummy/coverage/branch-coverage.xml')).to be_truthy
    end
  end
end
