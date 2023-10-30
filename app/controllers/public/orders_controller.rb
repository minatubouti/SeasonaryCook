class Public::OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = Order.new
    @item = Item.find(params[:item_id])
  end

  def create
     puts "Debug Params: #{params.inspect}"
    @item = Item.find(params[:order][:item_id]) 
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.shop_id = @item.shop_id  # @itemからshop_idを設定
    if @order.save
      redirect_to order_completed_user_orders_path(current_user)
    else
      render :new
    end
  end
  
  def completed
    @order = Order.find_by(id: params[:order_id])
    if @order.nil?
      redirect_to root_path, alert: '注文に失敗しました'
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :quantity, :payment, :quantity, :shop_id, :user_id, :item_id, :total_price)
  end
end
