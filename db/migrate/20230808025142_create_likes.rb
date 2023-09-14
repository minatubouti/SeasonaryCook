class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
    # 一意性インデックス、一意性のバリデーションと整合性が取れるようになる
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
