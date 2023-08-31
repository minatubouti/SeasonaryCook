require 'rails_helper'

RSpec.describe Like, type: :model do
  # 有効ないいねの場合
  it "投稿とユーザーが存在する場合は有効" do
    like = build(:like)
    expect(like).to be_valid
  end

  # postがない場合
  it "投稿がない場合無効" do
    like = build(:like, post: nil)
    like.valid?
    expect(like.errors[:post]).to include("を入力してください")
  end

  # userがない場合
  it "ユーザーがない場合無効" do
    like = build(:like, user: nil)
    like.valid?
    expect(like.errors[:user]).to include("を入力してください")
  end
end
