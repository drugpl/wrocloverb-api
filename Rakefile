#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

WrocLove::Application.load_tasks

Rake::TestTask.new("test:api") do |t|
  t.libs << 'test'
  t.pattern = 'test/api/**/*_test.rb'
end

task test: 'test:api'
