class AddShutdownToErrorList < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE error_lists ADD shutdown enum("no", "yes") DEFAULT "no";
    SQL
  end

  def down
    remove_column :error_lists, :shutdown
  end
end
