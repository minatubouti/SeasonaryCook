class Public::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  #before_action :reject_guest, only: [:update] 
  
  def new
   @post = Post.new
   @post.ingredients.build # 画面で使うための空の食材オブジェクト
   @post.recipe_steps.build # 画面で使うための空のレシピステップオブジェクト
  end
  
  def create
    @post = current_user.posts.new(post_params)
    @post.is_guest = current_user.guest? # ゲストユーザーの場合はフラグをセット
    if @post.save
      redirect_to posts_path, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました。必須の項目の入力をしてください'
      render :new
    end
  end
  
  def index
      @posts = Post.where(is_public: true, is_guest: false).includes(:user, :likes) #ゲスト、退会済みのユーザーの投稿を表示しないようにする
      if params[:search].present?
        # タイトル、主要な野菜、または季節に基づいて絞り込む
        posts_based_on_columns = @posts.where('title LIKE ? OR main_vegetable LIKE ? OR season LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
        # タグに基づいて絞り込む
        posts_based_on_tags = @posts.tagged_with(params[:search])
        # 両方のクエリの結果のIDを取得
        combined_post_ids = posts_based_on_columns.pluck(:id) + posts_based_on_tags.pluck(:id)
        # IDに基づいて最終的なクエリを構築
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
     
      @posts = @posts.page(params[:page])
  end



  def show
    @post = Post.find(params[:id])
    # 投稿が非公開で、現在のユーザーが投稿のオーナーでない場合（URLでのアクセスを防ぐ)
    if !@post.is_public && current_user != @post.user
      redirect_to root_path, alert: "閲覧権限がありません。"
      return
    end
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿が更新されました'
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end
  


  private
   
  def post_params
    params.require(:post).permit(
      :title, :description, :main_vegetable, :season, :is_public, :image, :tag_list, :serving_size,
      ingredients_attributes: [:id, :name, :amount],
      recipe_steps_attributes: [:id, :instructions] 
    )
  end
   
  # 自身の投稿かチェック
  def ensure_correct_user
     @post = Post.find(params[:id])
    unless @post.user == current_user
      flash[:alert] = '権限がありません。'
      redirect_to posts_path
    end
  end
   
end