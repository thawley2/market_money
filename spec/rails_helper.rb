def test_data
  @market1 = create(:market)
  @market2 = create(:market)
  @market3 = create(:market)
  @market4 = create(:market)

  @vendor1 = create(:vendor, credit_accepted: true)
  @vendor2 = create(:vendor)
  @vendor3 = create(:vendor)
  @vendor4 = create(:vendor)
  @vendor5 = create(:vendor)

  @mv1 = create(:market_vendor, market: @market1, vendor: @vendor1)
  @mv2 = create(:market_vendor, market: @market1, vendor: @vendor2)
  @mv3 = create(:market_vendor, market: @market1, vendor: @vendor3)
  @mv4 = create(:market_vendor, market: @market1, vendor: @vendor4)
  @mv5 = create(:market_vendor, market: @market2, vendor: @vendor1)
end

def market_data
  @market1 = create(:market, city: 'Ponca City', state: 'Oklahoma', name: 'Walmart')
  @market2 = create(:market, city: 'Edmond', state: 'Oklahoma', name: 'Target')
  @market3 = create(:market, city: 'Denver', state: 'Colorado', name: 'King Super')
  @market6 = create(:market, city: 'Denver', state: 'Colorado', name: 'Joes')
  @market4 = create(:market, city: 'Littleton', state: 'Colorado', name: 'Farmers')
  @market5 = create(:market, city: 'San Jose', state: 'California', name: 'Sprouts')
end



require 'simplecov'
SimpleCov.start
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
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
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryBot::Syntax::Methods
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<TMBD_API_KEY>') { ENV['TMBD_API_KEY'] }
  config.configure_rspec_metadata!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
     with.test_framework :rspec
     with.library :rails
  end
end
