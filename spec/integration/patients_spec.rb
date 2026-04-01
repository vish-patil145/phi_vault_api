# spec/requests/api/v1/patients_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/patients', type: :request do
  # ── POST /api/v1/patients ─────────────────────────────────────────────────
  path '/api/v1/patients' do
    post 'Create a patient' do
      tags        'Patients'
      consumes    'application/json'
      produces    'application/json'
      security    [ { bearerAuth: [] } ]

      parameter name: :patient, in: :body, schema: {
        '$ref' => '#/components/schemas/PatientInput'
      }

      response '201', 'patient created' do
        let(:Authorization) { "Bearer #{admin_jwt_token}" }  # helper from your spec/support
        let(:patient) { { name: 'Jane Doe', age: 30, gender: 'female' } }

        schema '$ref' => '#/components/schemas/Patient'
        run_test!
      end

      response '422', 'validation failed' do
        let(:Authorization) { "Bearer #{admin_jwt_token}" }
        let(:patient) { { name: '' } }   # intentionally invalid

        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid' }
        let(:patient) { { name: 'Jane', age: 25, gender: 'male' } }

        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    # ── GET /api/v1/patients ────────────────────────────────────────────────
    get 'List patients' do
      tags     'Patients'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      parameter name: :name,     in: :query, type: :string,  required: false, description: 'Filter by name (ILIKE)'
      parameter name: :age,      in: :query, type: :integer, required: false, description: 'Filter by exact age'
      parameter name: :page,     in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Records per page (default 10)'

      response '200', 'patients listed' do
        let(:Authorization) { "Bearer #{valid_jwt_token}" }
        let(:name)     { nil }
        let(:age)      { nil }
        let(:page)     { 1 }
        let(:per_page) { 10 }

        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Patient' }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer },
                     total_pages:  { type: :integer }
                   }
                 }
               }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid' }
        let(:name) { nil }; let(:age) { nil }; let(:page) { 1 }; let(:per_page) { 10 }

        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
end
