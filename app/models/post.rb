class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments
  has_many :bookmarks
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :recipe_steps, dependent: :destroy
  accepts_nested_attributes_for :recipe_steps, reject_if: :all_blank, allow_destroy: true
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients
  
  validates :title, :main_vegetable, :season, presence: true
  # 後悔するか判定
  validates :is_public, inclusion: { in: [true, false] }
  
  # 季節の選択肢
  SEASONS = ['春', '夏', '秋', '冬']

  # 季節のバリデーション
  validates :season, inclusion: { in: SEASONS }
  
  # 投稿を新しいものから順に取得するスコープ
  scope :recent, -> { order(created_at: :desc) }
  # キーワード検索を行うスコープ
  scope :search, ->(keyword) { where("content LIKE ?", "%#{keyword}%") }
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  
  # 特定のユーザーが投稿に「いいね」をしているかどうかをチェック
  def likes_by?(user)
    likes.exists?(user_id: user.id)
  end
  #同じくブックマークしているかをチェック
  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end
end
