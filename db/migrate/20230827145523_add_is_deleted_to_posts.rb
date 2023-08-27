class AddIsDeletedToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :is_deleted, :boolean, default: false
  end
end
