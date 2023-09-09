class Public::TagsController < ApplicationController
  def index
    if params[:search].present?
      @tags = ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:search]}%")
    else
      # 使用されている上位25個のタグを取得
      @tags = ActsAsTaggableOn::Tag.most_used(30)
    end
  end
  
  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @posts = Post.tagged_with(@tag.name)
  end
end
