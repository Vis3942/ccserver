class CreateInvalidPackets < ActiveRecord::Migration[6.0]
  def change
    create_table :invalid_packets do |t|
      t.string :packet
      t.datetime :received_at

      t.timestamps
    end
  end
end
