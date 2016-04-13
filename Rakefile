require 'rspec/core/rake_task'
require 'dotenv'
Dotenv.load
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :travis do
  desc 'load .env variables into travis env'
  task :env do
    %w{chef_url chef_key chef_client}.each do |w|
      key = w.upcase
      `travis env set -- #{key} '#{ENV[key]}'`
    end
  end
end

task :run do
  sh "slnky service run chef"
end
