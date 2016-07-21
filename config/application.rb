require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GenieacsGui
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.page_size = 10

    # Set preferred authentication method to use
    # :yml = use roles from roles.yml and users from users.yml
    config.auth_method = :yml
    # :db = use roles and users stored in the database
    #config.auth_method = :db
  end
end
