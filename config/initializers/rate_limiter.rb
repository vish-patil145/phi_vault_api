# config/initializers/rate_limiter.rb
require Rails.root.join("app/middleware/rate_limiter")
Rails.application.config.middleware.use Middleware::RateLimiter
