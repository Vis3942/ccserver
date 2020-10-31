class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :serial_number
      t.string :imei_number
      t.references :location, null: false, foreign_key: true
      t.string :service_tag
      t.string :firmware_version
      t.string :device_ping_data
      t.datetime :device_ping_at
      t.boolean :pay_per_use
      t.boolean :decommissioned
      t.boolean :missing
      t.datetime :from
      t.datetime :to
    end
    add_index :devices, :serial_number
    add_index :devices, :imei_number
    add_index :devices, :service_tag
  end
end
