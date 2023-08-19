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
  
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # 通知機能
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :inquiries, dependent: :destroy
  
  # emailが空でない、同じemail使用不可、形式をチェック
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # パスワード6字以上
  validates :password, length: { minimum: 6 }, if: :password_required?
  # name空でない15字以下
  validates :name, presence: true, length: { maximum: 15 }
         
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
     temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

    
     # ゲストメールアドレスを定数として定義
   GUEST_USER_EMAIL = "guest@example.com"

    def self.guest
      find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
        user.password = SecureRandom.urlsafe_base64
        user.name = "guest"
      end
    end
    
    def guest?
     email == GUEST_USER_EMAIL
    end
    
end
