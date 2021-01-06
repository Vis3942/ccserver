class AddCodeToErrorList < ActiveRecord::Migration[6.0]
  def change
    add_column :error_lists, :code, :string
    add_index :error_lists, :code, unique: true
  end
end
