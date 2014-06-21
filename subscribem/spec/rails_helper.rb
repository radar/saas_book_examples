# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../dummy/config/environment",  __FILE__)
require "rspec/rails"
require "capybara/rspec"
require "factory_girl"
require "database_cleaner"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.after(:each) do
    Apartment::Database.reset

    connection = ActiveRecord::Base.connection.raw_connection
    schemas = connection.query(%Q{
      SELECT 'drop schema ' || nspname || ' cascade;'
      from pg_namespace 
      where nspname != 'public' 
      AND nspname NOT LIKE 'pg_%'
      AND nspname != 'information_schema';
    })
    schemas.each do |query|
      connection.query(query.values.first)
    end
  end

  config.before(:all) do
    DatabaseCleaner.strategy = :truncation, 
      {:pre_count => true, :reset_ids => true}
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    Apartment::Database.reset
    DatabaseCleaner.clean
  end
end

Capybara.app_host = "http://example.com"