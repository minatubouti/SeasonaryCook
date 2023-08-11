class Public::PostsController < ApplicationController
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
  end
  
  private
   
   def post_params
    params.require(:post).permit(
      :title, :description, :main_vegetable, :season, :is_public, :image,
      ingredients_attributes: [:id, :name, :amount],
      recipe_steps_attributes: [:id, :instructions] 
    )
   end
end