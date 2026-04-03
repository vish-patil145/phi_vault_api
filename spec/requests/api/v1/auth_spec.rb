require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  let(:url) { "/api/v1/auth" }

  before do
    # Prevent rate limiting issues
    Rack::Attack.reset! if defined?(Rack::Attack)
  end

  describe "POST /api/v1/auth" do
    context "when credentials are valid" do
      let!(:user) do
        User.create!(
          email: "test@example.com",
          password: "password123"
        )
      end

      let(:valid_params) do
        {
          email: "test@example.com",
          password: "password123"
        }
      end

      it "returns 200 OK" do
        post url, params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it "returns a JWT token" do
        post url, params: valid_params

        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
      end

      it "returns a valid JWT payload" do
        post url, params: valid_params

        json = JSON.parse(response.body)
        decoded = JwtService.decode(json["token"])

        expect(decoded["user_id"]).to eq(user.id)
      end
    end

    # ─────────────────────────────────────────────

    context "when password is incorrect" do
      let!(:user) do
        User.create!(
          email: "test@example.com",
          password: "password123"
        )
      end

      let(:invalid_params) do
        {
          email: "test@example.com",
          password: "wrongpassword"
        }
      end

      it "returns 401 Unauthorized" do
        post url, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post url, params: invalid_params

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Invalid")
      end
    end

    # ─────────────────────────────────────────────

    context "when email does not exist" do
      let(:params) do
        {
          email: "notfound@example.com",
          password: "password123"
        }
      end

      it "returns 401 Unauthorized" do
        post url, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    # ─────────────────────────────────────────────

    context "when email is missing" do
      let(:params) do
        {
          password: "password123"
        }
      end

      it "returns 401 Unauthorized" do
        post url, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    # ─────────────────────────────────────────────

    context "when password is missing" do
      let(:params) do
        {
          email: "test@example.com"
        }
      end

      it "returns 401 Unauthorized" do
        post url, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    # ─────────────────────────────────────────────

    context "when both email and password are blank" do
      let(:params) do
        {
          email: "",
          password: ""
        }
      end

      it "returns 401 Unauthorized" do
        post url, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    # ─────────────────────────────────────────────

    context "when request body is empty" do
      it "returns 401 Unauthorized" do
        post url, params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
