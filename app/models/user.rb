class User < ApplicationRecord
  has_one_attached :icon_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_posts, through: :bookmarks, source: :post
  
  # :inverse_ofオプションを指定して、関連付けられたオブジェクト間で双方向の関連を持たせる
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy, inverse_of: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy, inverse_of: :followed
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # 通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy, inverse_of: :visitor
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy, inverse_of: :visited
  has_many :inquiries, dependent: :destroy
  has_one :shop, dependent: :destroy
  has_many :orders
  has_many :addresses, dependent: :destroy
  # emailが空でない、同じemail使用不可、形式をチェック
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # パスワード6字以上
  validates :password, length: { minimum: 6 }, if: :password_required?
  # name空でない15字以下
  validates :name, presence: true, length: { maximum: 15 }
  
  # 管理者が退会させた場合ログアウトを待たずに利用不可にする
  def active_for_authentication?
     # is_deletedがtrue（つまり退会済み）の場合にユーザーを非アクティブにしたいので、条件を!is_deletedとする
    super && !is_deleted
  end
  
  # active_for_authentication? メソッドがtrueを返すとinactive_message を呼び出しエラーメッセージを表示する
  def inactive_message
    is_deleted ? super : :account_inactive 
  end
  
  # current_userが「いいね」や「ブックマーク」した投稿の総数をカウントする場合に非公開の投稿や退会済みのユーザーの投稿を除外する
  def active_liked_posts_count
    likes.joins(post: :user).where(posts: { is_public: true }, users: { is_deleted: false }).count
  end

  def active_bookmarked_posts_count
    bookmarks.joins(post: :user).where(posts: { is_public: true }, users: { is_deleted: false }).count
  end
  
  # 退会していないユーザーのみを取得するスコープ（フォロー、フォロワー数のカウントで使用）
  scope :active, -> { where(is_deleted: false) }
        
  # 指定された他のユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # 指定された他のユーザーのフォローを外す
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 指定された他のユーザーをフォローしているかどうかをチェック
  def following?(other_user)
    following.include?(other_user)
  end    
    
    # フォロー通知の作成メソッド
  def create_notification_follow!(current_user)
     # すでに「フォロー」されたことがあるか検索
     temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
     # temp.blank?がtrue（すでに同じ通知がない場合通知を作成
    return if temp.present?

      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
  end

    
     # ゲストメールアドレスを定数として定義
  # .freezeを追加することで、そのオブジェクトは不変になり、後から内容を変更することができなくなる
  GUEST_USER_EMAIL = "guest@example.com".freeze

    def self.guest
      find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
        user.password = SecureRandom.urlsafe_base64
        user.name = "guest"
      end
    end
    
  # ゲストユーザーかどうかを判断するメソッド
    def guest?
      email == GUEST_USER_EMAIL
    end
end
