# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "dc_rake"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/test_*.rb"]
end

default_tasks = %i[test rubocop]
unless RUBY_VERSION.match?("3.[0-2]")
  require "dc_typing/rake"
  default_tasks.append("steep")
end

task default: default_tasks
