class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
    # 一意性インデックス
    add_index :bookmarks, [:user_id, :post_id], unique: true
  end
end
