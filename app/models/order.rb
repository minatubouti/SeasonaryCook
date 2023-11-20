class Order < ApplicationRecord
  belongs_to :item
  belongs_to :user
  belongs_to :address
  has_many :order_items
  enum payments: { credit_card: 0, bank_transfer: 1 }
  
  def total_price
    order_items.sum { |item| item.quantity * item.unit_price }
  end
end
