class Address < ApplicationRecord
  belongs_to :user

  # ユーザーの住所を表示するためのメソッド
  def address_display
    "#{self.postcode} #{self.address} #{self.name}"
  end
end
