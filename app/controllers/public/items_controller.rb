class Public::ItemsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @shop = Shop.find(params[:shop_id])
    @item = @shop.items.new
  end

  def create
    @shop = Shop.find(params[:shop_id])
    @item = @shop.items.new(item_params)
    if @item.save
      redirect_to user_shop_item_path(user_id: @shop.user_id, shop_id: @shop.id, id: @item.id), notice: '商品が登録されました'
    else
      flash.now[:alert] = '商品の登録に失敗しました'
      render :new
    end
  end


  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :stock_quantity, :item_image)
  end
end
