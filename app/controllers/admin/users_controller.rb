class Admin::UsersController < ApplicationController
   before_action :authenticate_admin! #管理者であることを確認
   before_action :find_user, only: [:show, :edit, :update, :destroy] 
   
  def index
    if params[:search].present?
      @users = User.where('name LIKE ?', "%#{params[:search]}%").page(params[:page])
    else
      @users = User.order(created_at: :desc).page(params[:page])
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
    @likes_count = @posts.sum { |post| post.likes.count }    # いいねの合計を計算
    @bookmarks_count = @posts.sum { |post| post.bookmarks.count } # ブックマークの合計を計算
    @comments_count = @posts.sum { |post| post.comments.count } #コメントの合計の計算
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'ユーザ情報を更新しました。'
    else
      render :edit
    end
  end
  
  def destroy
    if @user.destroy
      flash[:notice] = "ユーザーのデータを削除しました。"
      redirect_to admin_users_path 
    else
      flash[:alert] = "ユーザーの削除に失敗しました。"
      render :edit
    end
  end
  
  private
 
 #@user = User.find(params[:id])が共同で使えるようにする
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile, :icon_image, :is_deleted)
  end
end
