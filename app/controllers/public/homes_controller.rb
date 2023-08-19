class Public::HomesController < ApplicationController
  def top
    # 最新の投稿から5つの画像をランダムに取得
     rand = Rails.env.production? ? "rand()" : "RANDOM()"
     @images = Post.order(rand).limit(5).map { |post| url_for(post.image) }
  end

  def about
  end
end