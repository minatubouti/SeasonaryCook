class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.text :message
      t.text :reply
      t.boolean :replied, default: false

      t.timestamps
    end
  end
end
