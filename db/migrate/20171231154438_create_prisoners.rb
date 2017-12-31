class CreatePrisoners < ActiveRecord::Migration[5.1]
  def change
    create_table :prisoners do |t|
      t.string :name
      t.string :rank
      t.string :serial_number

      t.timestamps
    end
  end
end
