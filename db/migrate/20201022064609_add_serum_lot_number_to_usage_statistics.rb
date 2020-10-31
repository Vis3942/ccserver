class AddSerumLotNumberToUsageStatistics < ActiveRecord::Migration[6.0]
  def change
    add_column :usage_statistics, :serum_lot_number, :string
  end
end
