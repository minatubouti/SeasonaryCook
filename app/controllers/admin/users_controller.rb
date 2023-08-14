class Admin::UsersController < ApplicationController
   before_action :authenticate_admin! #管理者であることを確認
   
  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @likes_count = @posts.sum { |post| post.likes.count }    # いいねの合計を計算
    @bookmarks_count = @posts.sum { |post| post.bookmarks.count } # ブックマークの合計を計算
    @comments_count = @posts.sum { |post| post.comments.count } #コメントの合計の計算
  end

  def edit
  end
  
  def update
  end
  
  def destroy
  end
end
