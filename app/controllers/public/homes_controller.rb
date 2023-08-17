class Public::HomesController < ApplicationController
  def top
    # 最新の投稿から5つの画像をランダムに取得
     @images = Post.order("RANDOM()").limit(5).map { |post| url_for(post.image) }
  end

  def about
  end
end
