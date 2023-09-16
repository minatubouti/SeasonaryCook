class Public::BookmarksController < ApplicationController
  before_action :ensure_correct_user, only: [:destroy] #他のユーザーがブックマークを削除できないように
  
  def create
    @bookmark = current_user.bookmarks.create(post_id: params[:post_id])
    @post = @bookmark.post
    respond_to do |format|
     format.js
    end
  end
  
  def destroy
    # @bookmarkの取得をensure_correct_user内で行い、destroyアクションでその@bookmarkを利用する
    @post = @bookmark.post
    @bookmark.destroy
    respond_to do |format|
     format.js
    end
  end
  
  private

   # @bookmarkが現在のユーザーのものでなければ、リダイレクトして操作を中断させる
  def ensure_correct_user
    @bookmark = current_user.bookmarks.find_by(id: params[:id])
    # @bookmark が nil の場合にリダイレクトする、unless を使用する代わりに if 修飾子を使用
    redirect_to root_path, alert: '権限がありません' if @bookmark.nil?
  end
end
