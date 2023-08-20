class Public::HomesController < ApplicationController
  def top
      # 最新の投稿から5つを取得
    @posts = Post.order(created_at: :desc).limit(5)
    # RubyのArray#shuffleメソッドでランダムに並び替え
    @images = @posts.shuffle.map { |post| url_for(post.image) }
    
    # # 本番環境(mySQL)とSQLliteで関数を使い分ける
     # rand = Rails.env.production? ? "rand()" : "RANDOM()"
    # # 最新の投稿から5つの画像をランダムに取得
     # @images = Post.order(rand).limit(5).map { |post| url_for(post.image) }
  end

  def about
  end
end