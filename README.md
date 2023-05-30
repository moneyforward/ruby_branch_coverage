# branchcov-xmlruby-sonar


[![Coverage Status](https://coveralls.io/repos/github/moneyforwardvietnam/branchcov-xmlruby-sonar/badge.svg?branch=main&t=v4X7VE)](https://coveralls.io/github/moneyforwardvietnam/branchcov-xmlruby-sonar?branch=main)

下記をアプリ側の`spec_helper`に追加して使用してください

```ruby
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
```

`simplecov.rake`を動かす際には、下記のようにディレクトリを作成してコピーする必要があります
```ruby
# example of circleci/.config

- run:
  name: Stash coverage results
  command: |
    mkdir coverage_results
    cp -R coverage/.resultset.json coverage_results/.resultset-${CIRCLE_NODE_INDEX}.json || exit 0
```