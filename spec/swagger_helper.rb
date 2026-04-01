# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'PHI Vault API',
        version: 'v1',
        description: 'Patient Health Information Vault'
      },
      servers: [
        { url: 'http://localhost:3000', description: 'Development' }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          Patient: {
            type: :object,
            properties: {
              id:     { type: :integer },
              name:   { type: :string },
              age:    { type: :integer },
              gender: { type: :string, enum: %w[male female other] }
            },
            required: %w[name age gender]
          },
          PatientInput: {
            type: :object,
            properties: {
              name:   { type: :string, example: 'Jane Doe' },
              age:    { type: :integer, example: 30 },
              gender: { type: :string, enum: %w[male female other], example: 'female' }
            },
            required: %w[name age gender]
          },
          LoginInput: {
            type: :object,
            properties: {
              email:    { type: :string, format: 'email',    example: 'admin@phivault.com' },
              password: { type: :string, format: 'password', example: 'secret123' }
            },
            required: %w[email password]
          },
          AuthToken: {
            type: :object,
            properties: {
              token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9...' }
            },
            required: %w[token]
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string }
            }
          }
        }
      }
    }
  }

  config.swagger_format = :yaml
end
