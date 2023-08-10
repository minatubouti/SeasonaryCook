class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true # 外部キー制約の追加
      t.string :title, null: false
      t.text :description
      t.string :main_vegetable, null: false
      t.string :season, null: false
     
      t.boolean :is_public
      t.timestamps
  end 
  end
end
