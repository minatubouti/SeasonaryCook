class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to user_path(user)
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to user_path(user)
  end
  
  def followed
    @user = User.find(params[:user_id])
    @followers = @user.followers
  end
  
  def follower
    @user = User.find(params[:user_id])
    @followings = @user.following
  end
end
