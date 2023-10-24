class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
    @item = Item.find(params[:item_id])
  end

  def create
    @item = Item.find(params[:order][:item_id]) 
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.shop_id = @item.shop_id  # @itemからshop_idを設定
    if @order.save
      redirect_to order_completed_path
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :shop_id, :user_id, :item_id, :total_price)
  end
end
