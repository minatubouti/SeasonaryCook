class User < ApplicationRecord
  has_one_attached :icon_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments
  has_many :bookmarks
  has_many :bookmarked_posts, through: :bookmarks, source: :post
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  # emailが空でない、同じemail使用不可、形式をチェック
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # パスワード6字以上
  validates :password, length: { minimum: 6 }, if: :password_required?
  # name空でない15字以下
  validates :name, presence: true, length: { maximum: 15 }
         
    # ゲストメールアドレスを定数として定義
   GUEST_USER_EMAIL = "guest@example.com"

    def self.guest
      find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
        user.password = SecureRandom.urlsafe_base64
        user.name = "ゲストユーザー"
      end
    end

end
