class Public::PostsController < ApplicationController
  before_action :authenticate_user! # ログインチェック
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :reject_guest, only: [:new, :create, :edit, :update] #ゲストユーザか確認
  
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
    @posts = Post.where(is_public: true).includes(:user, :likes).recent.page(params[:page])
  
    if params[:search].present?
      @posts = @posts.where('title LIKE ? OR main_vegetable LIKE ? OR season LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
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
    @post = Post.find(params[:id])
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
   
  # 自身の投稿かチェック
   def ensure_correct_user
     @post = Post.find(params[:id])
    unless @post.user == current_user
      flash[:alert] = '権限がありません'
      redirect_to posts_path
    end
   end
   
  # ゲストユーザか判別
   def reject_guest
      if current_user&.guest?
        redirect_to root_path, alert: "ゲストユーザーは投稿できません。"
      end
   end
end