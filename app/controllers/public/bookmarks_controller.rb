class Public::BookmarksController < ApplicationController
  before_action :reject_guest_user, only: [:create, :destroy]
  
  def create
    @bookmark = current_user.bookmarks.create(post_id: params[:post_id])
    @post = @bookmark.post
    respond_to do |format|
     format.js
    end
  end
  
  def destroy
    @bookmark = Bookmark.find(params[:id])
    @post = @bookmark.post
    @bookmark.destroy
    respond_to do |format|
     format.js
    end
  end
end
