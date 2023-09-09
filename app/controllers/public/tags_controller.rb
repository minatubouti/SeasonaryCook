class Public::TagsController < ApplicationController
  def index
    if params[:search].present?
      @tags = ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:search]}%")
    else
      @tags = ActsAsTaggableOn::Tag.all
    end
  end
  
  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @posts = Post.tagged_with(@tag.name)
  end
end
