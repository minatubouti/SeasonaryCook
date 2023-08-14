class Admin::HomesController < ApplicationController
   before_action :authenticate_admin! # 管理者認証
  
  def top
  end
end
