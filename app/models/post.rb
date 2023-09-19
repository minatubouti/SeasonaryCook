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
  # accepts_nested_attributes_forで子かラムを一緒に保存できるようになる。
  accepts_nested_attributes_for :recipe_steps, reject_if: :all_blank, allow_destroy: true
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  # 通知に投稿IDがnilであることを許容する
  has_many :notifications, dependent: :nullify
 
  
  validates :title, :main_vegetable, :season, presence: true
  # 公開するか判定
  validates :is_public, inclusion: { in: [true, false] }
  
  # 季節の選択肢
  SEASONS = %w[春 夏 秋 冬].freeze

  # 季節のバリデーション
  validates :season, inclusion: { in: SEASONS }
  
  # 並び替え機能で使用
  # 投稿を新しいものから順に取得するスコープ
  scope :recent, -> { order(created_at: :desc) }
  # 投稿をいいねの多い順に取得するスコープ
  scope :popular, -> { left_joins(:likes).group(:id).order('COUNT(likes.id) DESC') }
  # 投稿を古いものから順に取得するスコープ
  scope :oldest, -> { order(created_at: :asc) }
  
  # キーワード検索のスコープ
  scope :search_by_keyword, lambda { |keyword|
    where('title LIKE ? OR main_vegetable LIKE ? OR season LIKE ?', "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
  }
  # タグ検索のスコープ
  scope :search_by_tag, lambda { |tag_name|
    tagged_with(tag_name)
  }
  
  # 画像がない場合no-image
  def post_image
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

  # 同じくブックマークしているかをチェック
  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end  
  
  # いいねを行った際に通知（Notification）を作成するメソッド、引数としてcurrent_user（いいねを行ったユーザー）を受け取ります。
  def create_notification_like!(current_user)
    user_id = self.user_id # self はこの場合 Post オブジェクトを指す(self.user_idは投稿の作成者のID)
    
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, 'like'])
  
    # temp.blank?がtrue（すでに同じ通知がない）であり、かつcurrent_user.id != user_id（自分自身の投稿にいいねしていない）場合、新しい通知レコードを作成
    if temp.blank? && current_user.id != user_id
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      notification.checked = true if notification.visitor_id == notification.visited_id
      # notificationオブジェクトが有効（valid?メソッドがtrueを返す）であれば、この通知を保存
      notification.save if notification.valid?
    end
  end
  
# コメント通知の作成メソッド
  def create_notification_comment!(current_user, comment_id)
  # 対象となる投稿（post_id: id）にコメントした人々（user_id）を検索します。ただしコメントが自分（current_user）によるものである場合は除外される
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      # 自分自身の投稿へのコメントでなければ通知を保存
      save_notification_comment!(current_user, comment_id, temp_id['user_id']) if current_user.id != temp_id['user_id']
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る（自分自身でなければ）
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank? && current_user.id != user_id
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id:,
      visited_id:,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  # 管理者による投稿更通知
  def create_update_notification(admin_id)
    Notification.create(
      visitor_id: admin_id, 
      visited_id: user_id,
      post_id: id,
      action: 'post_updated'
    )
  end

  # 管理者による投稿削除通知
  def create_destroy_notification(admin_id)
    Notification.create(
      visitor_id: admin_id,
      visited_id: user_id,
      post_id: id,
      action: 'post_destroyed'
    )
  end
end
