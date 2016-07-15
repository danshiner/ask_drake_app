require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require ::File.expand_path('../config/environment', __FILE__)
  end

  desc 'Retrieves the current schema version number'
  task :version do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end
end


# require evnviro in the rake file
# create rake command db:seed in call you call a seed.rb