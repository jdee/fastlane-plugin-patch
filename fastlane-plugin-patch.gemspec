# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/patch/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-patch'
  spec.version       = Fastlane::Patch::VERSION
  spec.author        = 'Jimmy Dee'
  spec.email         = 'jgvdthree@gmail.com'

  spec.summary       = 'Apply and revert pattern-based patches to any text file.'
  spec.homepage      = "https://github.com/jdee/fastlane-plugin-patch"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'pattern_patch', '>= 0.5.1'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rspec-simplecov'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fastlane', '>= 2.47.0'
end
