class RecipeStep < ApplicationRecord
  belongs_to :post
  # 作り方必須
  validates :instructions, presence: true
end
