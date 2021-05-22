class AddArchivedToUsageStatistic < ActiveRecord::Migration[6.0]
  def change
    add_column :usage_statistics, :archived, :boolean, default: false
  end
end
