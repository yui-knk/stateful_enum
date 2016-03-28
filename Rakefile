require "bundler/gem_tasks"
require "rake/testtask"
require 'yaml'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

namespace :test do
  task :all do
    YAML.load(File.read(File.expand_path('.travis.yml')))['gemfile'].each do |gemfile|
      sh "BUNDLE_GEMFILE='#{gemfile}' bundle exec rake test"
    end
  end
end
