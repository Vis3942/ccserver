class AddLanguageVersionToDevice < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :language_version, :string
  end
end
