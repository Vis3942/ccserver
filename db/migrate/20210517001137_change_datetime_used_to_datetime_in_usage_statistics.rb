class ChangeDatetimeUsedToDatetimeInUsageStatistics < ActiveRecord::Migration[6.0]
  def change
    change_column :usage_statistics, :datetime_used, :datetime
  end
end
