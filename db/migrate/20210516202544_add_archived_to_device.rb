class AddArchivedToDevice < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :archived, :boolean, default: false
  end
end
