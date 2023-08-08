# frozen_string_literal: true
require "rails"

# rubocop:disable Style/Documentation
class RubyBranchCoverage
  class Engine < ::Rails::Engine
    isolate_namespace RubyBranchCoverage
  end
end
# rubocop:enable Style/Documentation
