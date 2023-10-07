class Shop < ApplicationRecord
   has_one_attached :shop_icon
  belongs_to :user
  
  validates :user_id, presence: true
end
