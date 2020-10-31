class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :account_qb_id
      t.string :name
    end
    add_index :groups, :account_qb_id, unique: true
  end
end
