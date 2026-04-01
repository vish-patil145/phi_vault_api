class User < ApplicationRecord
  has_secure_password

  enum :role, { admin: 0, doctor: 1, nurse: 2, lab_technician: 3 }

  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: roles.keys }
end
