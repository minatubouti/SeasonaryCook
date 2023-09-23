class Admin::HomesController < ApplicationController
   before_action :authenticate_admin! # 管理者認証
  
  def top
    one_week_ago = 1.week.ago
    # ユーザー数
    @users_count = User.count
    # 退会済みユーザー数
    @deleted_users_count = User.where(is_deleted: true).count
    # １週間内の登録ユーザー数
    @new_users_count = User.where('created_at > ?', one_week_ago).count
    # １週間以内に投稿を行なったユーザー
    @active_users_count = User.joins(:posts).where('posts.created_at > ?', one_week_ago).distinct.count
    # 投稿合計数
    @posts_count = Post.count
    # １週間内の投稿数
    @new_posts_count = Post.where('created_at > ?', one_week_ago).count
    # １週間内のコメント数
    @new_comments_count = Comment.where('created_at > ?', one_week_ago).count 
     # 未返信のお問い合わせ件数を取得
    @unreplied_inquiries_count = Inquiry.where(replied: false).count
  end
end
