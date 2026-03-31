# app/models/phi_record.rb
class PhiRecord < ApplicationRecord
  belongs_to :patient
  def set_encrypted_data(data)
    self.encrypted_data = EncryptionService.encrypt(data)
  end

  def decrypted_data
    EncryptionService.decrypt(encrypted_data)
  end
end
