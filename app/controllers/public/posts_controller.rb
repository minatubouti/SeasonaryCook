class Public::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  def new
   @post = Post.new
   @post.ingredients.build # 画面で使うための空の食材オブジェクト
   @post.recipe_steps.build # 画面で使うための空のレシピステップオブジェクト
  end
  
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: '投稿しました'
    else
      render :new
    end
  end
  
  def index
    @posts = Post.recent.page(params[:page])# 新しい順に投稿を取得
  end

  def show
    @post = Post.find(params[:id])
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
    @post = post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end
  
  private
   
   def post_params
    params.require(:post).permit(
      :title, :description, :main_vegetable, :season, :is_public, :image,
      ingredients_attributes: [:id, :name, :amount],
      recipe_steps_attributes: [:id, :instructions] 
    )
   end
   
  # 自身の投稿か確認
   def ensure_correct_user
     @post = Post.find(params[:id])
    unless @post.user == current_user
      flash[:alert] = '権限がありません'
      redirect_to posts_path
    end
   end
end