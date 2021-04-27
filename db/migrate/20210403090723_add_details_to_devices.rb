class AddDetailsToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :language_packs, :string
    add_column :devices, :pay_per_use_grace_count, :integer
  end
end
