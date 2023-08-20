class Post < ApplicationRecord
  has_one_attached :image
  # タグ付け可能にする
  acts_as_taggable_on :tags
  
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :recipe_steps, dependent: :destroy
  accepts_nested_attributes_for :recipe_steps, reject_if: :all_blank, allow_destroy: true
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients
  has_many :notifications, dependent: :destroy
 
  
  validates :title, :main_vegetable, :season, presence: true
  # 後悔するか判定
  validates :is_public, inclusion: { in: [true, false] }
  
  # 季節の選択肢
  SEASONS = ['春', '夏', '秋', '冬']

  # 季節のバリデーション
  validates :season, inclusion: { in: SEASONS }
  
  # 並び替え機能で使用
  # 投稿を新しいものから順に取得するスコープ
  scope :recent, -> { order(created_at: :desc) }
  # 投稿をいいねの多い順に取得するスコープ
  scope :popular, -> { left_joins(:likes).group(:id).order('COUNT(likes.id) DESC') }
  # 投稿を古いものから順に取得するスコープ
  scope :oldest, -> { order(created_at: :asc) }

  # キーワード検索を行うスコープ
  scope :search, ->(keyword) { where("content LIKE ?", "%#{keyword}%") }
  
  # 画像がない場合no-image
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no-image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
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
  
# いいね通知の作成メソッド
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  
# コメント通知の作成メソッド
    def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        save_notification_comment!(current_user, comment_id, temp_id['user_id'])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
    end
  
    def save_notification_comment!(current_user, comment_id, visited_id)
      # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
      notification = current_user.active_notifications.new(
        post_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
    
end
