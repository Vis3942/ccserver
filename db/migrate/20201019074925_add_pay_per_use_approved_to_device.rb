class AddPayPerUseApprovedToDevice < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :pay_per_use_approved, :boolean
  end
end
