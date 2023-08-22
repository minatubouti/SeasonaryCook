class Public::UsersController < ApplicationController
  before_action :authenticate_user! # ログインチェック
  before_action :correct_user, only: [:edit, :update, :withdraw, :check_out]
  before_action :reject_guest, only: [:edit, :update, :withdraw, :check_out] #ゲストユーザか確認
  
  def show
    @user = User.find(params[:id])
   if current_user == @user
    @posts = @user.posts.order(created_at: :desc) # 自分のマイページなら全投稿
   else
    @posts = @user.posts.where(is_public: true).order(created_at: :desc) # 他人のマイページなら公開投稿のみ
   end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      flash[:alert] = "更新に失敗しました。"
      render :edit
    end
  end
  
  def likes
      @user = User.find(params[:id])
    if current_user == @user
      @liked_posts = @user.likes.includes(post: :user).map(&:post)
    else
      @liked_posts = @user.likes.includes(post: :user).where(posts: { is_public: true }).map(&:post)
    end
  end
  
  def bookmarks
      @user = User.find(params[:id])
    if current_user == @user
      @bookmarks = @user.bookmarks.includes(post: :user).map(&:post)
    else
      @bookmarks = @user.bookmarks.includes(post: :user).where(posts: { is_public: true }).map(&:post)
    end
  end
   
  def withdraw
     Rails.logger.debug "Current User: #{current_user.inspect}"
     current_user.update(is_deleted: true)
     reset_session
     redirect_to root_path, notice: '退会しました。'
  end

  
  private
  
    def user_params
     params.require(:user).permit(:icon_image, :name, :profile)
    end
    
    # ログインしているユーザーかチェック
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:alert] = "権限がありません。"
        redirect_to(root_url)
      end
    end
    
    def reject_guest
      if current_user&.guest?
        redirect_to root_path, alert: "ゲストユーザーはプロフィールの編集はできません。"
      end
    end
end
