class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      render :edit
    end
  end
  
  def likes
    @user = User.find(params[:id])
    @liked_posts = @user.likes.includes(post: :user).map(&:post)# 現在のユーザーがいいねした投稿を取得
  end
  
  def bookmarks
    @user = User.find(params[:id])
    @bookmarks = @user.bookmarks.includes(post: :user).map(&:post)
  end
   
  def withdraw
  end
  
  private
  
    def user_params
     params.require(:user).permit(:icon_image, :name, :profile)
    end
end
