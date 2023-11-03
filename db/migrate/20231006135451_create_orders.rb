class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :payment, null: false
      t.string :name, null: false
      t.string :postcode, null: false
      t.string :address, null: false
      t.integer :quantity, null: false
      t.string :order_status, null: false, default: 0
      t.timestamps
    end
  end
end
