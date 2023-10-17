class Item < ApplicationRecord
  has_one_attached :item_image
  belongs_to :shop
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
