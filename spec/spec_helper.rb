# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'simplecov'
SimpleCov.start

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

require_relative 'support/wait_for_ajax.rb'

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.include WaitForAjax, type: :feature

  # Database cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    `RAILS_ENV=test rake missql:reset`    
    @level_count = Level.count
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    ActiveRecord::Base.remove_connection    
    `RAILS_ENV=test rake missql:clean`
  end
  config.before(:each) do
    `RAILS_ENV=test rake missql:reload_all`
  end
  config.after(:each) do
    # User.destroy_all
    DatabaseCleaner.clean_with(:truncation)
  end  

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "default"
end
