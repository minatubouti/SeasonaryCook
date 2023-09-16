class Public::LikesController < ApplicationController
  before_action :ensure_correct_user, only: [:destroy] #他のユーザーがいいねを削除できないように
 
  def create
    @like = current_user.likes.create(post_id: params[:post_id])
    @post = @like.post
    # いいね通知の作成
    @post.create_notification_like!(current_user)
    respond_to do |format|
     format.js
    end
  end

  def destroy
    # @likeの取得をensure_correct_user内で行い、destroyアクションでその@likeを利用する
    @post = @like.post
    @like.destroy
    respond_to do |format|
     format.js
    end
  end
  
  private

 # @likeが現在のユーザーのものでなければ、リダイレクトして操作を中断させる
  def ensure_correct_user
    @like = current_user.likes.find_by(id: params[:id])
      redirect_to root_path, alert: '権限がありません。' if @like.nil?
  end
end
