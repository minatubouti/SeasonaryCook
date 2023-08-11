class RecipeStep < ApplicationRecord
  belongs_to :post
  validates :instructions, presence: true
end
