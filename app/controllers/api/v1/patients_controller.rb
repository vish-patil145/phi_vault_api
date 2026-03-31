class Api::V1::PatientsController < ApplicationController
  def create
    authorize!([ "admin" ])
    render json: Patient.create!(patient_params)
  end

  def index
    patients = Patient.all

    patients = patients.where("name ILIKE ?", "%#{params[:name]}%") if params[:name]
    patients = patients.where(age: params[:age]) if params[:age]

    patients = patients.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      data: patients,
      meta: {
        current_page: patients.current_page,
        total_pages: patients.total_pages
      }
    }
  end

  private

  def patient_params
    params.permit(:name, :age, :gender)
  end
end
