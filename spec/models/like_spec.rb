require 'rails_helper'

RSpec.describe Like, type: :model do
  # 有効ないいねの場合
  it "is valid with post and user" do
    like = build(:like)
    expect(like).to be_valid
  end

  # postがない場合
  it "is invalid without post" do
    like = build(:like, post: nil)
    like.valid?
    expect(like.errors[:post]).to include("を入力してください")
  end

  # userがない場合
  it "is invalid without user" do
    like = build(:like, user: nil)
    like.valid?
    expect(like.errors[:user]).to include("を入力してください")
  end
end
