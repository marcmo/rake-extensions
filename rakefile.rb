require './lib/rake-extensions'

desc "create new version and release"
task :create_release do
  current_tag = `git describe --tags`
  versioner = Versioner.for(:gemspec, ".")
  current_version = versioner.get_current_version
  require 'highline'
  cli = HighLine.new
  cli.choose do |menu|
    default = :minor
    menu.prompt = "this will create and tag a new version (default: #{default}) "
    menu.choice(:minor) do
      create_and_tag_new_version(versioner, :minor)
    end
    menu.choice(:major) do
      create_and_tag_new_version(versioner, :major)
    end
    menu.choice(:patch) do
      create_and_tag_new_version(versioner, :patch)
    end
    menu.choice(:abort) { cli.say("ok...maybe later") }
    menu.default = default
  end
end
def create_and_tag_new_version(versioner, jump)
  current_version = versioner.get_current_version
  next_version = versioner.get_next_version(jump)
  assert_tag_exists(current_version)
  create_changelog(current_version, next_version)
  versioner.increment_version(jump)
  sh "git add ."
  sh "git commit -m \"[](chore): version bump from #{current_version} => #{next_version.to_s}\""
  sh "git tag #{next_version.to_s}"
  puts "to undo the last commit and the tag, execute:"
  puts "git reset --hard HEAD~1 && git tag -d #{next_version.to_s}"
end

def gem_file_name
  versioner = Versioner.for(:gemspec, ".")
  current_version = versioner.get_current_version
  "rake-extensions-#{current_version}.gem"
end

file gem_file_name do
  sh "gem build rake-extensions.gemspec"
end

desc 'build'
task :gem => gem_file_name do
  puts `ls`
end

desc 'upload to ruby gems'
task :upload do
  sh "gem push #{gem_file_name}"
end