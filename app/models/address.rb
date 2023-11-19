class Address < ApplicationRecord
  belongs_to :user

  # ユーザーの住所を表示するためのメソッド
  def full_address
    "#{self.postcode} #{self.street} #{self.city} #{self.country}"
  end
end
