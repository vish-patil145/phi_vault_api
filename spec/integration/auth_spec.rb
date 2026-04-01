# spec/integration/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/api/v1/auth' do
    post 'Generate JWT token (Login)' do
      tags        'Authentication'
      consumes    'application/json'
      produces    'application/json'
      description 'Authenticates a user with email and password. Returns a signed JWT token on success.'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email:    { type: :string, example: 'admin@hospital.com' },
          password: { type: :string, example: 'password123', format: 'password' }
        },
        required: %w[email password]
      }

      # ── 200 Success ────────────────────────────────────────────────────────
      response '200', 'login successful' do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9...' }
               },
               required: %w[token]

        let(:credentials) do
          user = User.create!(
            email:    'admin@phivault.com',
            password: 'secret123'
          )
          { email: user.email, password: 'secret123' }
        end

        run_test!
      end

      # ── 401 Invalid credentials ────────────────────────────────────────────
      response '401', 'invalid credentials' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid' }
               },
               required: %w[error]

        let(:credentials) { { email: 'wrong@example.com', password: 'badpass' } }

        run_test!
      end

      # ── 401 Missing params ─────────────────────────────────────────────────
      response '401', 'missing email or password' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid' }
               }

        let(:credentials) { { email: '', password: '' } }

        run_test!
      end
    end
  end
end
