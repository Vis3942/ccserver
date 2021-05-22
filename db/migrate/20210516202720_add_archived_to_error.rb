class AddArchivedToError < ActiveRecord::Migration[6.0]
  def change
    add_column :errors, :archived, :boolean, default: false
  end
end
