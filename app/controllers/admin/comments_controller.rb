class Admin::CommentsController < ApplicationController
   before_action :authenticate_admin!
   
  def index
    @comments = Comment.order(created_at: :desc).page(params[:page])
  end
  
  def destroy
     comment = Comment.find(params[:id])
     comment.destroy
     redirect_to admin_comments_path, notice: 'コメントを削除しました。'
  end
end
 