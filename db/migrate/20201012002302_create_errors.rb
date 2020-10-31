class CreateErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :errors do |t|
      t.references :device, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.datetime :occured_at
      t.integer :error_code
    end
  end
end
