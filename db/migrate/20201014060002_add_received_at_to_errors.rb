class AddReceivedAtToErrors < ActiveRecord::Migration[6.0]
  def change
    add_column :errors, :received_at, :datetime
  end
end
