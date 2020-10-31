class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :group, null: false, foreign_key: true
      t.string :shipto_qb_id
      t.string :shipto_qb_name
      t.string :shipto_qb_address_l1
      t.string :shipto_qb_address_l2
      t.string :shipto_qb_city
      t.string :shipto_qb_state
      t.string :shipto_qb_zip
      t.string :shipto_qb_country
      t.string :shipto_qb_contact
      t.string :shipto_qb_phone_number
      t.string :time_zone
    end
    add_index :locations, :shipto_qb_id, unique: true
    add_index :locations, :shipto_qb_name
    add_index :locations, :shipto_qb_phone_number
  end
end
