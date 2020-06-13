class CreateDosens < ActiveRecord::Migration[6.0]
  def change
    create_table :dosens do |t|
      t.string :nama_dosen, null: false
      t.string :nidn_dosen, null: true

      t.timestamps
    end
  end
end
