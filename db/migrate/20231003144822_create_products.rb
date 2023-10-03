class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      # ショップが削除されたときにそのショップに紐づく商品も自動的に削除されるようにする
      t.references :shop, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.integer :price, null: false
      t.integer :stock
      t.text :description
      t.timestamps
    end
  end
end
