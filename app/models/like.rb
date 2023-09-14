class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  # 同じ投稿を複数回いいねさせないためのバリデーション
  validates :user_id, uniqueness: { scope: :post_id }
end
