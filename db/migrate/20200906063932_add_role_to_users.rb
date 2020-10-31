class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE users ADD role enum("techsupport", "admin");
    SQL
  end

  def down
    remove_column :users, :role
  end

end
