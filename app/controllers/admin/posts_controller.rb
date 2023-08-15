class Admin::PostsController < ApplicationController
  before_action :authenticate_admin! # 管理者認証
  
  
  def index
     @posts = Post.includes(:user, :likes).recent.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿が削除されました'
  end
  
end
