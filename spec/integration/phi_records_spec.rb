# spec/integration/phi_records_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/phi_records', type: :request do
  path '/api/v1/phi_records' do
    post 'Create a PHI record' do
      tags        'PHI Records'
      consumes    'application/json'
      produces    'application/json'
      security    [ { bearerAuth: [] } ]

      parameter name: 'Idempotency-Key', in: :header, type: :string, required: true
      parameter name: :phi_record, in: :body, schema: {
        '$ref' => '#/components/schemas/PhiRecordInput'
      }

      response '201', 'record created' do
        let(:Authorization)       { "Bearer #{doctor_token}" }
        let(:'Idempotency-Key')   { SecureRandom.uuid }
        let(:phi_record) do
          {
            patient_id: create(:patient).id,
            data: {
              diagnosis: "Hypertension",
              symptoms: [ "headache" ],
              doctor_notes: "Monitor BP"
            }
          }
        end
        schema '$ref' => '#/components/schemas/PhiRecord'
        run_test!
      end

      response '200', 'idempotent — duplicate request returns existing record' do
        let(:existing)            { create(:phi_record) }
        let(:Authorization)       { "Bearer #{doctor_token}" }
        let(:'Idempotency-Key')   { existing.request_id }
        let(:phi_record)          { { patient_id: existing.patient_id, data: {} } }
        run_test!
      end

      response '403', 'forbidden — nurse cannot create' do
        let(:Authorization)     { "Bearer #{nurse_token}" }
        let(:'Idempotency-Key') { SecureRandom.uuid }
        let(:phi_record)        { { patient_id: 1, data: {} } }
        run_test!
      end
    end

    get 'List PHI records' do
      tags     'PHI Records'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      parameter name: :status,     in: :query, type: :string,  required: false
      parameter name: :patient_id, in: :query, type: :integer, required: false
      parameter name: :page,       in: :query, type: :integer, required: false
      parameter name: :per_page,   in: :query, type: :integer, required: false

      response '200', 'records listed' do
        let(:Authorization) { "Bearer #{doctor_token}" }
        let(:status)        { nil }
        let(:patient_id)    { nil }
        let(:page)          { 1 }
        let(:per_page)      { 10 }
        run_test!
      end
    end
  end

  path '/api/v1/phi_records/{id}' do
    get 'Show PHI record' do
      tags     'PHI Records'
      produces 'application/json'
      security [ { bearerAuth: [] } ]

      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'record shown with role masking' do
        let(:Authorization) { "Bearer #{nurse_token}" }
        let(:id)            { create(:phi_record).id }
        run_test!
      end

      response '404', 'not found' do
        let(:Authorization) { "Bearer #{doctor_token}" }
        let(:id)            { 99999 }
        run_test!
      end
    end
  end
end
