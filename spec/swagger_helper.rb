# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s        # ← was swagger_root=

  config.openapi_specs = {                                      # ← was swagger_docs=
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'PHI Vault API',
        version: 'v1'
      },
      servers: [ { url: 'http://localhost:3000' } ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  config.openapi_format = :yaml                                 # ← was swagger_format=
end
