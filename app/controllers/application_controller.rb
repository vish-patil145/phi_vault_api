class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  private

  # 🔐 Authenticate user from JWT
  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = JwtService.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded["user_id"])
      render_unauthorized unless @current_user
    else
      render_unauthorized
    end
  end

  # 🔒 Authorization (RBAC)
  def authorize!(roles)
    unless roles.include?(current_user.role)
      render json: { error: "Forbidden" }, status: :forbidden and return
    end
  end

  # 🚫 Common unauthorized response
  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized and return
  end
end
