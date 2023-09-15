class Admin::PostsController < ApplicationController
  before_action :authenticate_admin! # 管理者認証
  before_action :find_post, only: %i[show edit update destroy] 
  
  
  def index
    # 初期状態で全ての投稿を取得（N+1問題を防ぐため、関連するユーザーやいいねを先読み）
    @posts = Post.all.includes(:user, :likes)
  
     # キーワード検索がある場合
    if params[:search].present?
      # キーワードに基づいて投稿を検索
      keyword_posts_ids = @posts.search_by_keyword(params[:search]).pluck(:id)
      # キーワードに基づいてタグから投稿を検索
      tag_posts_ids = Post.search_by_tag(params[:search]).pluck(:id)
    　# 上記2つの検索結果を統合し、重複を除去
      combined_post_ids = keyword_posts_ids + tag_posts_ids
      @posts = @posts.where(id: combined_post_ids.uniq) # 重複するIDを除去するためにuniqを使用
    end

   # タグ検索
    @posts = @posts.search_by_tag(params[:tag]) if params[:tag].present?
  
    # 並べ替え機能
    if params[:popular]
      @posts = @posts.popular
    elsif params[:oldest]
      @posts = @posts.oldest
    else
      # デフォルトは新しい順にする
      @posts = @posts.recent 
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
