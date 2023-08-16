class Admin::PostsController < ApplicationController
  before_action :authenticate_admin! # 管理者認証
  before_action :find_user, only: [:show, :edit, :update, :destroy] 
  
  
  def index
     @posts = Post.includes(:user, :likes).recent.page(params[:page])
  end

  def show
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: '投稿が更新されました。'
    else
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿が削除されました'
  end
  
  private
  #@user = User.find(params[:id])が共同で使えるようにする
  def find_user
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:title, :tag_list, :season, :is_public)
  end
end
