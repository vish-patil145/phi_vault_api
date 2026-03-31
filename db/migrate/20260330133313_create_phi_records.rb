class CreatePhiRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :phi_records do |t|
      t.references :patient, null: false, foreign_key: true
      t.text :encrypted_data
      t.string :status
      t.string :request_id

      t.timestamps
    end
    add_index :phi_records, :request_id, unique: true
  end
end
