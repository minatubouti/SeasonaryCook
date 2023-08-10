class Post < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :comments
  has_many :bookmarks
  has_many :ingredients
  
  # 投稿を新しいものから順に取得するスコープ
  scope :recent, -> { order(created_at: :desc) }
  # キーワード検索を行うスコープ
  scope :search, ->(keyword) { where("content LIKE ?", "%#{keyword}%") }
end
