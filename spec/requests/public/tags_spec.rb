require 'rails_helper'

RSpec.describe "Public::Tags", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/public/tags/index"
      expect(response).to have_http_status(:success)
    end
  end

end
