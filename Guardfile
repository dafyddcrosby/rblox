# frozen_string_literal: true

directories(%w[. exe lib test].select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") })

guard :rake, task: "default" do
  watch("Gemfile")
  watch("Rakefile")
  watch("Guardfile")
  watch(%r{^test/helper\.rb$})
  watch(%r{^test/test_(.*)\.rb$})
  watch(%r{^lib/rblox/(.*)\.rb$})
  watch(%r{^lib/(.*)\.rb$})
  watch(%r{^exe/(.*)\.rb$})
end
