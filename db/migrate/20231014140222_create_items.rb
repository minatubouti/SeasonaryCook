class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price, null: false
      t.integer :stock_quantity, null: false, default: 0
      t.boolean :is_active, null: false, default: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
