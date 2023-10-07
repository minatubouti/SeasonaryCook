class Public::ShopsController < ApplicationController
 before_action :ensure_correct_user, only: [:new, :create]
  
  # すでにショップを持っている場合、再度ショップを作成することを防ぐ
  def new
    if current_user.shop.present?
      redirect_to user_shop_path(current_user, current_user.shop), alert: 'ショップ開設済みです'
      return
    end
    @shop = current_user.build_shop
  end

  
  def create
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to user_shop_path(current_user, @shop), notice: 'ショップを開設しました'
    else
      render :new
    end
  end
  
  def show
    @shop = Shop.find(params[:id])
  end
  
  private
  
  def shop_params
    params.require(:shop).permit(:name, :description, :address, :post_code, :shop_icon)
  end
  
  def ensure_correct_user
    # ここでユーザーが正しいかどうかのチェックを行う。
    if current_user.id != params[:user_id].to_i
      redirect_to root_path, alert: '不正なアクセスです'
    end
  end
end
