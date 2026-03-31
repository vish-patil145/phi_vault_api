# app/services/jwt_service.rb
class JwtService
  JWT_SECRET = Rails.application.credentials.dig(:jwt, :jwt_secret)

  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, JWT_SECRET, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, JWT_SECRET, true, { algorithm: "HS256" })[0]
  end
end
