class Ingredient < ApplicationRecord
  belongs_to :post
 
  # 食材名、数量必須
  validates :name, :amount, presence: true
end
