require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    #
    config.action_mailer.perform_caching = false
    config.action_mailer.default_url_options = { host: '167.172.102.203' }
    config.action_mailer.delivery_method = :smtp
    # config.action_mailer.perform_deliveries = true
    # config.action_mailer.default :charset => "utf-8"
    config.action_mailer.smtp_settings = {
        address: 'smtp.gmail.com',
        port: 587,
        # domain: 'peaceful-harbor-42154.herokuapp.com',
        user_name: ENV['SMTP_USERNAME'],
        password: ENV['SMTP_PASSWORD'],
        authentification: 'plain',
        enable_starttls_auto: true
    }


    config.autoload_paths += [config.root.join('app')]

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end
  end
end
