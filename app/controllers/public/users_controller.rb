class Public::UsersController < ApplicationController
  before_action :authenticate_user! # ログインチェック
  before_action :find_user, only: %i[show edit update likes bookmarks]  # find_userを使用するアクション
  before_action :correct_user, only: %i[edit update withdraw check_out]
  before_action :reject_guest, only: %i[edit update withdraw check_out] # ゲストユーザか確認
 
  
  def show
     # 退会済みのユーザーの場合(urlでのアクセスを防ぐ)
    if @user.is_deleted
      flash[:alert] = "このユーザーは退会済みです。"
      redirect_to root_path
      return
    end
    
    # ゲストユーザーのマイページを閲覧しようとしているが、現在のユーザーがゲストユーザーでない場合
    if @user.guest? && !current_user.guest?
      redirect_to root_path, alert: 'ゲストユーザーのページは表示できません。'
      return
    end
    
    @posts = if current_user == @user
               @user.posts.order(created_at: :desc) # 自分のマイページなら全投稿
             else
               @user.posts.where(is_public: true).order(created_at: :desc) # 他人のマイページなら公開投稿のみ
             end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      flash[:alert] = "更新に失敗しました。"
      render :edit
    end
  end
  
  def likes
    # 関連する投稿の情報を効率的に取得するために、joinsメソッドを使用
    @liked_posts = @user.likes.joins(:post).where(posts: { is_public: true }).map(&:post)
  end
  
  def bookmarks
    @bookmarks = @user.bookmarks.joins(:post).where(posts: { is_public: true }).map(&:post)
  end
   
  def withdraw
    Rails.logger.debug "Current User: #{current_user.inspect}"
    current_user.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: '退会しました。'
  end
  
  def check_out
  end

  
  private
  
  def user_params
    params.require(:user).permit(:icon_image, :name, :profile)
  end
  
  def find_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:alert] = "指定されたユーザーは存在しないか、削除されました。"
      redirect_to root_path
    end
  end
  
  # ログインしているユーザーかチェック
  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path, alert: "不正なアクセスです。"
    end
  end
  
  def reject_guest
    if current_user&.guest?
      redirect_to root_path, alert: "ゲストユーザーはプロフィールの編集はできません。"
    end
  end
end
