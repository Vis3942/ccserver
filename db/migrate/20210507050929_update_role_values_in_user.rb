class UpdateRoleValuesInUser < ActiveRecord::Migration[6.0]
  def up
    execute_statement('ALTER TABLE users MODIFY role enum("admin", "s2", "s1", "manufacturingtech", "logistics", "finance")') 
  end
  
  def down
    execute_statement('ALTER TABLE users MODIFY role enum("techsupport", "admin", "s2", "s1", "manufacturingtech", "logistics", "finance")') 
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
