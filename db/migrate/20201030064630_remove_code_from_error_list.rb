class RemoveCodeFromErrorList < ActiveRecord::Migration[6.0]
  def change
    remove_column :error_lists, :code, :int
  end
end
