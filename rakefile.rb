require './lib/rake-extensions'

desc 'build new gem version'
task :increment do
  versioner = Versioner.for(:gemspec, ".")
  current_version = versioner.get_current_version
  next_version = versioner.get_next_version(:minor)
  assert_tag_exists(current_version)
  create_changelog(current_version, next_version)
  versioner.increment_version(:minor)
  sh "git add ."
  sh "git commit -m \"[](chore): version bump from #{current_version} => #{next_version.to_s}\""
  sh "git tag #{next_version.to_s}"
  puts "to undo the last commit and the tag, execute:"
  puts "git reset --hard HEAD~1 && git tag -d #{next_version.to_s}"
end