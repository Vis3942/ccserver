class RemoveLanguageVersionFromDevices < ActiveRecord::Migration[6.0]
  def change
    remove_column :devices, :language_version, :string
  end
end
