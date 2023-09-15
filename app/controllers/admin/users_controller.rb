class Admin::UsersController < ApplicationController
   before_action :authenticate_admin! #管理者であることを確認
   before_action :find_user, only: %i[show edit update destroy] # find_userを使うアクション
   include ApplicationHelper #ApplicationHelperに定義されたメソッドをAdmin::UsersControllerでも使えるようにする
   
  def index
    if params[:search].present?
      @users = User.where('name LIKE ?', "%#{params[:search]}%").page(params[:page])
    else
      @users = User.order(created_at: :desc).page(params[:page])
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
     # ヘルパーメソッドを使用して退会済みユーザーのカウントを除外
    @likes_count = @posts.sum { |post| active_likes_count(post) }         # ユーザーのいいねの合計を計算
    @bookmarks_count = @posts.sum { |post| active_bookmarks_count(post) } # ユーザーのブックマークの合計を計算
    @comments_count = @posts.sum { |post| active_comments_count(post) }   # ユーザーのコメントの合計の計算
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'ユーザー情報を更新しました。'
    else
      flash[:alert] = "ユーザー情報更新に失敗しました。"
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
 
 # find_userが共同で使えるようにする
  def find_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:alert] = "指定されたユーザーは存在しないか、削除されました。"
      redirect_to admin_users_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :profile, :icon_image, :is_deleted)
  end
end
