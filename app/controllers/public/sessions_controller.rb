# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # 退会済みのユーザーがログインできないようにし、適切なメッセージを表示する
  before_action :withdraw, only: [:create]
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
 
  protected

  def after_sign_in_path_for(resource)
    user_path(current_user) # ユーザーログイン後のリダイレクト先
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  
  def withdraw
     @user = User.find_by(email: params[:user][:email])
    if @user&.valid_password?(params[:user][:password]) && @user.is_deleted
      redirect_to new_user_session_path, alert: 'アカウントは退会済みです。'
    end
  end
  
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
