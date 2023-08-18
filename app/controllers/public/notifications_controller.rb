class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
     # 現在ログインしているユーザーの通知を取得
    @notifications = current_user.passive_notifications.order(created_at: "DESC")

    # 未読の通知を「既読」に更新
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
