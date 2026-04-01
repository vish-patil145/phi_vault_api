class Patient < ApplicationRecord
  has_many :doctors, through: :appointments

  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :gender, inclusion: { in: %w[Male Female Other male female other] }
end
