class Public::LikesController < ApplicationController
  def index
  end
  
  def create
   @like = current_user.likes.create(post_id: params[:post_id])
   @post = @like.post
   respond_to do |format|
    format.js
  end
end
  
  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    @like.destroy
    respond_to do |format|
     format.js
    end
  end
end
