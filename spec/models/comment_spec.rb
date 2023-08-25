require 'rails_helper'

RSpec.describe Comment, type: :model do
 # 有効なコメントの場合
  it "is valid with content, post, and user" do
    comment = build(:comment)
    expect(comment).to be_valid
  end

  # コメント内容が必須の場合
  it "is invalid without content" do
    comment = build(:comment, content: nil)
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end

  # コメント内容が100文字以下の場合
  it "is valid with content less than or equal to 100 characters" do
    comment = build(:comment, content: "a" * 100)
    expect(comment).to be_valid
  end

  # コメント内容が100文字より多い場合
  it "is invalid with content more than 100 characters" do
    comment = build(:comment, content: "a" * 101)
    comment.valid?
    expect(comment.errors[:content]).to include("は100文字以内で入力してください")
  end

  # postがない場合
  it "is invalid without post" do
    comment = build(:comment, post: nil)
    comment.valid?
    expect(comment.errors[:post]).to include("を入力してください")
  end

  # userがない場合
  it "is invalid without user" do
    comment = build(:comment, user: nil)
    comment.valid?
    expect(comment.errors[:user]).to include("を入力してください")
  end
end
