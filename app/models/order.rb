class Order < ApplicationRecord
  belongs_to :item
  belongs_to :user
  belongs_to :address
  has_many :order_items
  enum payments: { credit_card: 0, bank_transfer: 1 }
end
