# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  
  protected
  
  def after_sign_in_path_for(_resource)
    admin_path # 管理者ログイン後のリダイレクト先
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_admin_session_path # 管理者ログアウト後のリダイレクト先
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
