class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.string :name
      t.string :model
      t.string :manufacturer
      t.integer :cost

      t.timestamps
    end
  end
end
