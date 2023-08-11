class CreateRecipeSteps < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_steps do |t|
      t.references :post, foreign_key: true
      t.text :instructions

      t.timestamps
    end
  end
end
