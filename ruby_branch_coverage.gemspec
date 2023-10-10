require_relative 'lib/ruby_branch_coverage/version'

Gem::Specification.new do |s|
    s.name        = 'ruby_branch_coverage'
    s.version     = RubyBranchCoverage::VERSION
    s.summary     = 'Branch Coverage Ruby!'
    s.description = 'A program to convert json to xml test coverage format gem'
    s.authors     = ['Suganya']
    s.email       = ['kuppusamy.suganya@moneyforward.co.jp']
    s.files = Dir["{config,lib}/**/*", "Rakefile"]
    s.homepage    =
      'https://rubygems.pkg.github.com/moneyforward/ruby_branch_coverage'

    s.metadata["allowed_push_host"] = 'https://rubygems.pkg.github.com'
    s.add_development_dependency "rspec-rails"
    s.add_dependency "rails"
    s.add_dependency 'simplecov'
end
