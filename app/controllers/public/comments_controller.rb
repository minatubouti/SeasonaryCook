class Public::CommentsController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      # コメント通知の作成
     @post.create_notification_comment!(current_user, @comment.id)
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
      end
    else
      render 'public/posts/show'
    end
  end

  private
 
  def comment_params
    params.require(:comment).permit(:content)
  end
end
