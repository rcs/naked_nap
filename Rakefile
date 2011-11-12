require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--format nested --color']
end

desc "Run RSpec with code coverage"
task :coverage do
  ENV['COVERAGE'] = "true"
  Rake::Task["spec"].execute
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files = %w(lib/**/*.rb)
  end
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
