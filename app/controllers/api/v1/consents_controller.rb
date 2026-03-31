class Api::V1::ConsentsController < ApplicationController
  def create
    Consent.create!(params.permit(:patient_id, :granted_to, :granted))
  end
end
