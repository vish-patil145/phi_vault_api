# app/models/patient.rb
class Patient < ApplicationRecord
  has_many :phi_records, dependent: :destroy
  has_many :consents,    dependent: :destroy

  GENDERS = %w[Male Female Other male female other].freeze

  validates :name,   presence: true
  validates :age,    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :gender, presence: true, inclusion: { in: GENDERS }
end