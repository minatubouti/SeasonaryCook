class Admin::InquiriesController < ApplicationController
 before_action :authenticate_admin!
  before_action :set_inquiry, only: [:show, :update]
  
  def index
    @inquiries = Inquiry.all
  end

  def show
  end

  def update
    # 返信を更新する際にrepliedフィールドも同時に更新
    if @inquiry.update(reply_params.merge(replied: true))
      # 通知を作成
      message_notification_reply(@inquiry)
      redirect_to admin_inquiries_path, notice: '返信を送信しました。'
    else
      render :show
    end
  end
  
  
  private
  
  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end

  def reply_params
    params.require(:inquiry).permit(:reply)
  end
  
   # ここで通知を作成するロジックを追加します。Notificationモデルを使用して通知を保存する。
  def message_notification_reply(inquiry)
    Notification.create!(
      visitor_id: current_admin.id, # 管理者ID
      visited_id: inquiry.user_id,  # お問い合わせしたユーザーID
      inquiry_id: inquiry.id, # お問い合わせID
      action: 'reply',
      message: inquiry.reply        # 返信内容
    )
  end
end