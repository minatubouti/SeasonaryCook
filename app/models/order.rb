class Order < ApplicationRecord
  belongs_to :user
  enum payments: { credit_card: 0, bank_transfer: 1 }
end
