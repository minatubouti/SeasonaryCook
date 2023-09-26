require 'rails_helper'

RSpec.describe "Public::Users", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET #show" do
    context "ログインしている場合" do
      before do
        sign_in user
        get "/users/#{user.id}"
      end

      it "正常にレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200ステータスが返ってくる" do
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      before do
        get "/users/#{user.id}"
      end

      it "ログインページにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #edit" do
    context "認証済みのユーザーとして" do
      before do
        sign_in user
        get "/users/#{user.id}/edit"
      end

      it "正常にレスポンスを返す" do
        expect(response).to be_successful
      end
    end

    context "他のユーザーとして" do
      before do
        sign_in other_user
        get "/users/#{user.id}/edit"
      end

      it "root_pathにリダイレクトする" do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "POST #update" do
    before do
      sign_in user # ユーザーをサインインさせる
    end
    context '更新に成功した場合' do
      it 'ユーザー詳細ページにリダイレクトされる' do
        patch user_path(user), params: { user: { name: 'New Test User' } }
        user.reload
        expect(user.name).to eq('New Test User')
        expect(response).to redirect_to user_path(user)
      end
    end

    context '更新に失敗した場合' do
      it 'editにリダイレクトされエラーが表示される' do
        patch user_path(user), params: { user: { name: '' } }
        user.reload
        expect(user.name).not_to eq('')
        # 更新に失敗した場合エラーメッセージが表示されるか
        expect(response.body).to include("更新に失敗しました。")
      end
    end
  end
  
  describe "GET #likes" do
      it "いいね一覧ページが表示される" do
      user = FactoryBot.create(:user)
      liked_post = FactoryBot.create(:post)
      # ユーザーをサインインさせる
      sign_in user
      # ユーザーが投稿にいいねする
      FactoryBot.create(:like, user: user, post: liked_post)
  
      get "/users/#{user.id}/likes"
      # いいね一覧ページ」が正常に表示された場合、HTTPステータスコードとして200（OK）が返される
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe "GET #bookmarks" do
  it "ブックマーク一覧ページが表示される" do
    user = FactoryBot.create(:user)
    bookmarked_post = FactoryBot.create(:post)
    sign_in user
    # ユーザーが投稿にブックマークする
    FactoryBot.create(:bookmark, user: user, post: bookmarked_post)

    get "/users/#{user.id}/bookmarks"
    expect(response).to have_http_status(:ok)
  end
end

  describe "PUT #withdraw" do
    it "退会することができる" do
      user = FactoryBot.create(:user)
      sign_in user
      
      patch "/users/#{user.id}/withdraw"
      
      expect(user.reload.is_deleted).to be true
      expect(response).to redirect_to(root_path)
    end
  end
  
   describe "GET #check_out" do
    it "退会確認画面にリダイレクトする" do
      user = FactoryBot.create(:user)
      sign_in user
  
      get "/users/#{user.id}/check_out"
  
      expect(response).to have_http_status(:ok)
    end
  end
end
