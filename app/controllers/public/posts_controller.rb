class Public::PostsController < ApplicationController
  before_action :find_post, only: %i[show edit update destroy] # find_postが先に読み込まれるようにする
  before_action :ensure_correct_user, only: %i[edit update destroy]
  
  def new
    @post = Post.new
    @post.ingredients.build # 画面で使うための空の食材オブジェクト
    @post.recipe_steps.build # 画面で使うための空のレシピステップオブジェクト
  end
  
  def create
    @post = current_user.posts.new(post_params)
    @post.is_guest = current_user.guest? # ゲストユーザーの場合はフラグをセット
    if @post.save
      redirect_to post_path(@post), notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました。必須の項目の入力をしてください'
      render :new
    end
  end
  
  def index
    @posts = Post.where(is_public: true, is_guest: false).includes(:user, :likes) # ゲスト、退会済みのユーザーの投稿を表示しないようにする
    if params[:search].present?
      # キーワードに基づいて投稿を検索
      keyword_posts_ids = @posts.search_by_keyword(params[:search]).pluck(:id)
      # キーワードに基づいてタグから投稿を検索
      tag_posts_ids = Post.search_by_tag(params[:search]).pluck(:id)
      # 上記2つの検索結果を統合し、重複を除去
      combined_post_ids = keyword_posts_ids + tag_posts_ids
      # IDに基づいて最終的なクエリを構築
      @posts = @posts.where(id: combined_post_ids.uniq) # 重複するIDを除去するためにuniqを使用
    end
    # タグ検索のクエリがある場合はその条件でさらに絞り込む
    @posts = @posts.search_by_tag(params[:tag]) if params[:tag].present?
    
    # 並べ替え機能
    @posts = if params[:popular]
               @posts.popular
             elsif params[:oldest]
               @posts.oldest
             else
               @posts.recent # デフォルトは新しい順にする
             end
    @posts = @posts.page(params[:page])
  end

  def show
    # 投稿が非公開で、現在のユーザーが投稿のオーナーでない場合かつ投稿のオーナーが退会済みの場合（URLでのアクセスを防ぐ)
    if (!@post.is_public && current_user != @post.user) || @post.user.is_deleted
      redirect_to root_path, alert: "閲覧権限がありません。"
      return
    end
    @comments = @post.comments.order(created_at: :desc)
  end  
    
  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿が更新されました'
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end
  

  private
  
  def find_post
    @post = Post.find_by(id: params[:id])
    unless @post
      # 投稿が削除されている場合urlでアクセス時にエラーにならないように
      redirect_to posts_path, alert: '指定された投稿は存在しないか、削除されました。'
    end
  end
   
  def post_params
    params.require(:post).permit(
      :title, :description, :main_vegetable, :season, :is_public, :image, :tag_list, :serving_size,
      ingredients_attributes: %i[id name amount _destroy],
      recipe_steps_attributes: %i[id instructions _destroy] 
    )
  end
   
  # 自身の投稿かチェック
  def ensure_correct_user
    unless @post.user == current_user
      flash[:alert] = '権限がありません。'
      redirect_to posts_path
    end
  end
end
