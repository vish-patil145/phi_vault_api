# spec/requests/api_spec.rb
require 'swagger_helper'

RSpec.describe 'API', type: :request do
  path '/api/v1/patients' do
    get 'List patients' do
      tags 'Patients'
      produces 'application/json'

      response '200', 'success' do
        run_test!
      end
    end
  end
end
