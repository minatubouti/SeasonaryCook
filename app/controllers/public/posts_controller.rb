class Public::PostsController < ApplicationController
  def new
   @post = Post.new
   @post.ingredients.build # 画面で使うための空の食材オブジェクト
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
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  private
   
  def post_params
   params.require(:post).permit(:title, :description, :main_vegetable, :season, :instructions, :is_public, :image, ingredients_attributes: [:name, :amount])
  end
end
