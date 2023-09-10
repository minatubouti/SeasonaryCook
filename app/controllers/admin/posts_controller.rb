class Admin::PostsController < ApplicationController
  before_action :authenticate_admin! # 管理者認証
  before_action :find_post, only: [:show, :edit, :update, :destroy] 
  
  
  def index
    # 初期状態で全ての投稿を取得します
    @posts = Post.all.includes(:user, :likes)
  
    # タイトル、主要な野菜、または季節に基づいて絞り込む検索機能
    if params[:search].present?
      posts_based_on_columns = @posts.where('title LIKE ? OR main_vegetable LIKE ? OR season LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      posts_based_on_tags = @posts.tagged_with(params[:search])
      combined_post_ids = posts_based_on_columns.pluck(:id) + posts_based_on_tags.pluck(:id)
      @posts = @posts.where(id: combined_post_ids)
    end
  
    # タグ検索のクエリがある場合はその条件でさらに絞り込む
    if params[:tag].present?
      @posts = @posts.tagged_with(params[:tag])
    end
  
    # 並べ替え機能
    if params[:popular]
      @posts = @posts.popular
    elsif params[:oldest]
      @posts = @posts.oldest
    else
      @posts = @posts.recent # デフォルトは新しい順にする
    end
  end

  def show
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: '投稿が更新されました。'
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿が削除されました'
  end
  
  private
  #@user = User.find(params[:id])が共同で使えるようにする
  def find_post
    @post = Post.find_by(id: params[:id])
    unless @post
      # 投稿が削除されている場合urlでアクセス時にエラーにならないように
      redirect_to admin_posts_path, alert: '指定された投稿は存在しないか、削除されました。'
    end
  end

  
  def post_params
    params.require(:post).permit(:title, :tag_list, :season, :is_public)
  end
end
