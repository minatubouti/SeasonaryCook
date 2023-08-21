class AddServingSizeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :serving_size, :integer
  end
end
