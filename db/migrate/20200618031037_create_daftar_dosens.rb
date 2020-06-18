class CreateDaftarDosens < ActiveRecord::Migration[6.0]
  def change
    create_table :daftar_dosens do |t|
      t.string :nama_dosen, null: false
      t.string :nidn_dosen

      # t.timestamps
    end
  end
end
