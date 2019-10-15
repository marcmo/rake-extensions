# Rake Extensions

a collection of utilities that come in handy when writing rake tasks.

I've been using rake since 2005 and it's so simple and useful that I do all my automation with rake. Still, there are a couple of things that I found myself adding to all of my rakefiles. So this is should serve as a comprehensive gem that makes it easy to add those utilities to every rake file.

## Usage

```ruby
require 'rake-extensions'

task :a do
  puts "a"
  sleep(0.6)
end

task :b => :a do
  puts "b"
  sleep(0.5)
end

desc 'my awesome task'
task :c => :b do
  puts "c"
  sleep(0.1)
end
```
