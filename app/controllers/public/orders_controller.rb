class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
    @item = Item.find(params[:item_id])
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to order_completed_path
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :shop_id, :user_id, :item_id)
  end
end
