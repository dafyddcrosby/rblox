# frozen_string_literal: true

require_relative "lib/rblox/version"

Gem::Specification.new do |spec|
  spec.name = "rblox"
  spec.required_ruby_version = ">= 2.6.0"
  spec.version     = Rblox::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["David Crosby"]
  spec.homepage    = "https://daveops.net"
  spec.summary     = "Lox interpreter"
  spec.description = "Lox interpreter as seen in Crafting Interpreters"
  spec.license     = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test)/|\.(?:git))})
    end
  end
  spec.bindir = "exe"
end
