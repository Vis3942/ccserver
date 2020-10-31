class CreateErrorLists < ActiveRecord::Migration[6.0]
  def change
    create_table :error_lists do |t|
      t.integer :code
      t.string :description
    end
  end
end
