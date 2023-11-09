class Public::AddressesController < ApplicationController
  before_action :authenticate_user!
  
    def new
     @user = User.find(params[:user_id])  
     @address = Address.new
    end
  
    def index
      @addresses = current_user.addresses
      @address = Address.new
    end

    def edit
      @address = Address.find(params[:id])
    end
  
    def create
      @address = Address.new(address_params)
      @address.user_id = current_user.id
      if  @address.save
        flash[:notice] = "配送先の登録に成功しました"
        redirect_to addresses_path
      else
        @addresses = current_user.addresses
        redirect_to addresses_path
      end
    end

    def update
      @address = Address.find(params[:id])
      if @address.update(address_params)
        flash[:notice] = "配送先の更新に成功しました"
        redirect_to addresses_path
      else
        redirect_to edit_address_path(@address)
      end
    end
  
    def destroy
      @address = Address.find(params[:id])
      @address.destroy
      @address = current_user.addresses
       flash[:notice] = "登録内容は正常に削除されました"
       redirect_to addresses_path
    end

  private

  def address_params
    params.require(:address).permit(:postcode, :name, :address).merge(user_id: current_user.id)
  end
end
