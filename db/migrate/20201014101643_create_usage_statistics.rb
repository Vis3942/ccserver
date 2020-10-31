class CreateUsageStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :usage_statistics do |t|
      t.references :device, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.datetime :received_at
      t.string :cartridge_tag_id
      t.string :serum_name
      t.string :serum_lot_number
      t.string :treatment_time
      t.string :datetime_used
      t.string :board_temperature
      t.string :min_co2_temperature
      t.string :max_co2_temperature
      t.string :average_co2_temperature
      t.string :tank_tag_id
      t.string :tank_time_remaining
    end
  end
end
