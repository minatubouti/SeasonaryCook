class Public::HomesController < ApplicationController
  def top
    # 本番環境(mySQL)とSQLliteで関数を使い分ける
     rand = Rails.env.production? ? "rand()" : "RANDOM()"
     # 最新の投稿から5つの画像をランダムに取得
     @images = Post.order(rand).limit(5).map { |post| url_for(post.image) }
  end

  def about
  end
end