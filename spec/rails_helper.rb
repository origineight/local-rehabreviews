# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'simplecov-console'

ENV['COV_FORMAT'] ||= 'console'

SimpleCov.formatter = SimpleCov::Formatter::Console if ENV['COV_FORMAT'] == 'console'
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production? || Rails.env.staging?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'pry-byebug'
require 'faker'
require 'rake'
require 'elasticsearch/extensions/test/cluster/tasks'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

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
  config.include FactoryGirl::Syntax::Methods
  config.include FeatureHelpers, type: :feature

  config.after :each do
    Warden.test_reset!
  end

  config.before :suite do
    unless Elasticsearch::Extensions::Test::Cluster.running?
      Elasticsearch::Model.client = Elasticsearch::Client.new url: 'http://127.0.0.1:9250'
      Elasticsearch::Extensions::Test::Cluster.start(nodes: 1)
    end
  end

  config.around :each do |example|
    feature_or_es = example.metadata[:type] == :feature || example.metadata[:elasticsearch]

    if feature_or_es
      Listing.__elasticsearch__.create_index!(force: true)
      Listing.__elasticsearch__.refresh_index!
    end

    example.run

    Listing.__elasticsearch__.client.indices.delete index: Listing.index_name if feature_or_es
  end

  config.after :suite do
    Elasticsearch::Extensions::Test::Cluster.stop if Elasticsearch::Extensions::Test::Cluster.running?
  end
end

Capybara.configure do |config|
  config.javascript_driver = :selenium
  config.server_port = 3000
  config.app_host = "http://localhost"
  config.default_driver = :rack_test
  config.default_max_wait_time = 15
  config.asset_host = 'http://localhost:3000'
  config.always_include_port = true
end

def seo_listing_path(listing)
  ApplicationController.new.seo_listing_path(listing)
end
