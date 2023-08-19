class AddIsGuestToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :is_guest, :boolean, default: false
  end
end
