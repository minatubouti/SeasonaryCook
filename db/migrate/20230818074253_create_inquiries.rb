class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :email
      t.text :message
      t.text :reply
      t.boolean :replied

      t.timestamps
    end
  end
end
