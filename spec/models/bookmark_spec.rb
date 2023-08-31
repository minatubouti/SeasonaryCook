require 'rails_helper'

RSpec.describe Bookmark, type: :model do
   # 有効なブックマークの場合
  it "投稿とユーザーが存在する場合は有効" do
    bookmark = build(:bookmark)
    expect(bookmark).to be_valid
  end

  # 同じ投稿を同じユーザーが複数回ブックマークする場合
  it "同じ投稿を同じユーザーが複数回ブックマークする場合は無効" do
    bookmark1 = create(:bookmark)
    bookmark2 = build(:bookmark, post: bookmark1.post, user: bookmark1.user)
    bookmark2.valid?
    expect(bookmark2.errors[:user_id]).to include("はすでに存在します")
  end

  # postがない場合
  it "投稿が存在しない場合は無効" do
    bookmark = build(:bookmark, post: nil)
    bookmark.valid?
    expect(bookmark.errors[:post]).to include("を入力してください")
  end

  # userがない場合
  it "ユーザーが存在しない場合は無効" do
    bookmark = build(:bookmark, user: nil)
    bookmark.valid?
    expect(bookmark.errors[:user]).to include("を入力してください")
  end
end
