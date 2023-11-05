class Public::OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = Order.new
    @item = Item.find(params[:item_id])
  end

  def create
    @item = Item.find_by(id: params[:order][:item_id])
    
    if @item.nil?
      # Itemが見つからない場合の処理
      flash[:alert] = '商品が見つかりません。'
      redirect_to some_path
      return
    end
  
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.shop_id = @item.shop_id  
    @order.order_status = 0  # ステータスをセット
    
  
    if @order.save
      # 注文が保存された後の処理
      redirect_to completed_user_order_path(current_user, @order), notice: '注文が完了しました。'
    else
      render :new
    end
  end
  
  def completed
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :quantity, :payment, :shop_id, :user_id, :item_id, :total_price)
  end
  
  def order_item_params
    params.require(:order_datail).permit(:order_id, :item_id, :quantity, :buy_price)
  end
end
