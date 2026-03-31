require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

# ✅ Correct require (no Rails.root here)
require_relative "../app/middleware/rate_limiter"

module PhiVaultApi
  class Application < Rails::Application
    config.load_defaults 8.1

    config.api_only = true
    config.active_job.queue_adapter = :sidekiq

    config.middleware.use Middleware::RateLimiter
  end
end
