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
end
