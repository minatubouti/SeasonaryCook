require 'rails_helper'

RSpec.describe "Public::Posts", type: :request do
  
   describe 'GET #new' do
    it '新規投稿ページが表示されること' do
      get new_post_path 
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
  context '正常なパラメータの場合' do
    it '新規投稿が成功すること' do
      expect {
        post :create, params: { post: FactoryBot.attributes_for(:post) }
      }.to change(Post, :count).by(1)
    end
  end
  
  context '不正なパラメータの場合' do
    it '新規投稿が失敗すること' do
      expect {
        post posts_path, params: { post: FactoryBot.attributes_for(:post, title: nil) }
      }.to_not change(Post, :count)
    end
  end
end

  describe 'GET #index' do
    it '投稿一覧ページが表示されること' do
      get posts_path
      expect(response).to render_template :index
    end
  end

end
