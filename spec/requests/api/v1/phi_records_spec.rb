# spec/requests/api/v1/phi_records_spec.rb

require 'rails_helper'

RSpec.describe "PhiRecords API", type: :request do
  describe "POST /api/v1/phi_records" do
    it "handles idempotency" do
      headers = { "Idempotency-Key" => "123" }

      post "/api/v1/phi_records", headers: headers

      expect {
        post "/api/v1/phi_records", headers: headers
      }.not_to change(PhiRecord, :count)
    end
  end
end
