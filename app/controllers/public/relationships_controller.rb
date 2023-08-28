class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    # フォロー通知の作成
    user.create_notification_follow!(current_user)
    redirect_to user_path(user)
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to user_path(user)
  end
  
  def followed
    @user = User.find(params[:user_id])
    # (退会していない）の条件を加え、退会しているユーザーは表示でされないようにする
    @followers = @user.followers.where(is_deleted: false).page(params[:page])
  end
  
  def follower
    @user = User.find(params[:user_id])
    @followings = @user.following.where(is_deleted: false).page(params[:page])
  end
end
