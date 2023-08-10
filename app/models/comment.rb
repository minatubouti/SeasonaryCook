class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  # コメント内容必須
  validates :content, presence: true
  # 文字数に制限
  validates :content, length: { minimum: 5, maximum: 100 }
end
