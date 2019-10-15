require './lib/rake-extensions'

desc 'build new gem version'
task :build do
  versioner = Versioner.for(:gemspec, ".")
  current_version = versioner.get_current_version
  puts "current version: #{current_version}"
  next_version = versioner.get_next_version(:minor)
  puts "next version: #{next_version}"
  # assert_tag_exists(current_version)
  # create_changelog(current_version, next_version)
  # versioner.increment_version(jump)
end