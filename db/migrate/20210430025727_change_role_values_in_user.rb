class ChangeRoleValuesInUser < ActiveRecord::Migration[6.0]

  def up
    #execute <<-SQL
    #  ALTER TABLE admin_users MODIFY role enum("admin", "user")    
    #SQL
    execute_statement('ALTER TABLE users MODIFY role enum("techsupport", "admin", "s2", "s1", "manufacturingtech", "logistics", "finance")') 
  end
  
  def down
    execute_statement('ALTER TABLE users MODIFY role enum("techsupport", "admin")') 
  end


  def execute_statement(sql)
    results = ActiveRecord::Base.connection.execute(sql)
  
    if results.present?
      return results
    else
      return nil
    end
  end

end
