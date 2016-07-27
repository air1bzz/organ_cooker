require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.verbose = true
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/**/*spec*.rb']
end

task :default => :test
