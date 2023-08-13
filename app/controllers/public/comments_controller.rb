class Public::CommentsController < ApplicationController
  before_action :reject_guest_user, only: [:create]
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
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
