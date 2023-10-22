class Public::ShopsController < ApplicationController
 before_action :authenticate_user!
 before_action :find_shop, only: %i[show edit updata]
 before_action :ensure_correct_user, only: %i[edit update]
  
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
    # ショップに関連するアイテムを取得
    @items = @shop.items
  end
  
  def edit; end
  
  def update
    if @shop.update(shop_params)
      redirect_to user_shop_path(@shop), notice: 'ショップ情報を更新しました'
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end
  
  private
  
  def shop_params
    params.require(:shop).permit(:name, :description, :address, :post_code, :shop_icon)
  end
  
  def find_shop
    @shop = Shop.find(params[:id])
  end
  
  def ensure_correct_user
    @shop = Shop.find(params[:id])
    # ここでユーザーが正しいかどうかのチェックを行う。
    return if @shop.user_id == current_user.id

      redirect_to root_path, alert: '不正なアクセスです'
    
  end
end
