class Public::ItemsController < ApplicationController
  def new
    @shop = Shop.find(params[:shop_id])
    @item = @shop.items.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to shop_item_path(@item.shop, @item)
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :stock_quantity)
  end
end
