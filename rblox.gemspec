# frozen_string_literal: true

require_relative "lib/rblox/version"

Gem::Specification.new do |spec|
  spec.name = "rblox"
  spec.required_ruby_version = ">= 3.0.0"
  spec.version     = RbLox::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["David Crosby"]
  spec.homepage    = "https://daveops.net"
  spec.summary     = "Lox interpreter"
  spec.description = "Lox interpreter as seen in Crafting Interpreters"
  spec.license     = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = File.read("Manifest.txt").split
  spec.bindir = "exe"
end
