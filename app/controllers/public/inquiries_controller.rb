class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!
   
  def new
    @inquiry = Inquiry.new
  end

  def create
     @inquiry = current_user.inquiries.new(inquiry_params) 
    if @inquiry.save
      redirect_to root_path, notice: 'お問い合わせを受け付けました。'
    else
      Rails.logger.debug @inquiry.errors.full_messages
      render :new
    end
  end
  
  def show
    @inquiry = Inquiry.find(params[:id])
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :message)
  end
end
