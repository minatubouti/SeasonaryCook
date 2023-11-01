class Public::OrdersController < ApplicationController
  before_action :authenticate_user!
  
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
      redirect_to completed_orders_path(rder_id: @order.id)
    else
      render :new
    end
  end
  
  def completed
    @order = Order.find_by(id: params[:order_id])
    if @order.nil?
      redirect_to root_path, alert: '注文に失敗しました'
    else
      redirect_to completed_orders_path(order_id: @order.id)
    end
    return
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :quantity, :payment, :shop_id, :user_id, :item_id, :total_price)
  end
end
