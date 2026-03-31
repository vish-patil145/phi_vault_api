class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :age
      t.string :gender

      t.timestamps
    end
  end
end
