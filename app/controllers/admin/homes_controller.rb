class Admin::HomesController < ApplicationController
   before_action :authenticate_admin! # 管理者認証
  
  def top
    one_week_ago = 1.week.ago
    @new_users_count = User.where('created_at > ?', one_week_ago).count
    @new_posts_count = Post.where('created_at > ?', one_week_ago).count
    @new_comments_count = Comment.where('created_at > ?', one_week_ago).count 
    @active_users_count = User.joins(:posts).where('posts.created_at > ?', one_week_ago).distinct.count
  end
end
