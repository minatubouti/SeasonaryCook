require 'rails_helper'

RSpec.describe Comment, type: :model do
 # 有効なコメントの場合
  it "投稿とユーザーが存在する場合は有効" do
    comment = build(:comment)
    expect(comment).to be_valid
  end

  # コメント内容が必須の場合
  it "コメント内容がない場合コメントできない" do
    comment = build(:comment, content: nil)
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end

  # コメント内容が100文字以下の場合
  it "コメントが100文字以内の場合コメントできる" do
    comment = build(:comment, content: "a" * 100)
    expect(comment).to be_valid
  end

  # コメント内容が100文字より多い場合
  it "コメントが100文字以上の場合コメントできない" do
    comment = build(:comment, content: "a" * 101)
    comment.valid?
    expect(comment.errors[:content]).to include("は100文字以内で入力してください")
  end

  # postがない場合
  it "投稿がない場合無効" do
    comment = build(:comment, post: nil)
    comment.valid?
    expect(comment.errors[:post]).to include("を入力してください")
  end

  # userがない場合
  it "ユーザーがない場合無効" do
    comment = build(:comment, user: nil)
    comment.valid?
    expect(comment.errors[:user]).to include("を入力してください")
  end
end
