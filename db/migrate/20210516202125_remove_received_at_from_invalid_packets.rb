class RemoveReceivedAtFromInvalidPackets < ActiveRecord::Migration[6.0]
  def change
    remove_column :invalid_packets, :received_at, :datetime
  end
end
