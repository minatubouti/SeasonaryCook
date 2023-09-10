class Public::TagsController < ApplicationController
  def index
    # タグのキーワード検索が行われた場合
    if params[:search].present?
      @tags = ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:search]}%")
    else
    # タグの検索が行われなかった場合、最も多く使用された上位30のタグを表示
      @tags = ActsAsTaggableOn::Tag.most_used(30)
    end
    # AJAXリクエストの場合、部分的なHTMLを返す
    if request.xhr?
      render partial: 'tags', locals: { tags: @tags }, layout: false
    end
  end
  
  # 特定のタグに関連する投稿一覧を表示
  def show
    # 選択されたタグを取得
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    # 該当するタグが付与された投稿を取得し、特定の条件（非公開、ゲスト、退会済みのユーザーの投稿を除外）で絞り込む
    @posts = Post.tagged_with(@tag.name)
                .where(is_deleted: false, is_guest: false) # 退会済み、ゲストユーザーの投稿を除外
                .where(is_public: true) # 公開投稿のみを取得
  end
end
