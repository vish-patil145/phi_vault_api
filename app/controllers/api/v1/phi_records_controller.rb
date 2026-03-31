class Api::V1::PhiRecordsController < ApplicationController
  include Authenticate

  def create
    Authorization.authorize!(@current_user, [ "doctor" ])

    request_id = request.headers["Idempotency-Key"]

    record = IdempotencyService.find_or_create(request_id) do
      PhiRecord.create!(
        patient_id: params[:patient_id],
        status: "pending",
        request_id: request_id
      )
    end

    record.set_encrypted_data(params[:data])
    record.save!

    ProcessPhiJob.perform_later(record.id)

    render json: record
  end

  def index
    records = PhiRecord.all

    records = records.where(status: params[:status]) if params[:status]
    records = records.where(patient_id: params[:patient_id]) if params[:patient_id]

    records = records.page(params[:page])

    render json: records
  end

  def show
    record = PhiRecord.find(params[:id])

    authorize!([ "doctor", "admin", "nurse" ])

    render json: mask_data(record)
  end

  private

  def mask_data(record)
    data = record.decrypt

    if current_user.role == "nurse"
      data["diagnosis"] = "MASKED"
    end

    data
  end
end
