class Notification < ApplicationRecord
  # デフォルトの並び順を「作成日時の降順」で指定、に新しい通知からデータを取得することができる
  default_scope -> { order(created_at: :desc) }
  belongs_to :visitor, class_name: 'User', optional: true
  belongs_to :visited, class_name: 'User', optional: true
  # optional: trueは、nilを許可するもの
  belongs_to :post, optional: true 
  belongs_to :comment, optional: true
  # お問い合わせとの関連付け
  belongs_to :inquiry, optional: true 
end
