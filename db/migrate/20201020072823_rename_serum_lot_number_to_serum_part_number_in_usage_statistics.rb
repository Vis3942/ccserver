class RenameSerumLotNumberToSerumPartNumberInUsageStatistics < ActiveRecord::Migration[6.0]
  def change
    rename_column :usage_statistics, :serum_lot_number, :serum_part_number
  end
end
