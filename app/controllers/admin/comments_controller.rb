class Admin::CommentsController < ApplicationController
   before_action :authenticate_admin!
   
  def index
    @comments = Comment.order(created_at: :desc).page(params[:page])
  end
  
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    post_id = comment.post_id # post_idを定義
    
    # リファラーURLからリダイレクト先を判定
    if request.referer&.include?("admin/posts/#{post_id}")
      # 詳細ページでコメントを削除した場合
      redirect_to admin_post_path(post_id), notice: 'コメントを削除しました。'
    else
      # コメント一覧ページで削除した場合
      redirect_to admin_comments_path, notice: 'コメントを削除しました。'
    end
  end
end
 