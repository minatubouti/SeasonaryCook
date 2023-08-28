require 'rails_helper'

RSpec.describe User, type: :model do
  
  # アソシエーションのテスト
  describe "Associations" do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_posts).through(:likes).source(:post) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmarked_posts).through(:bookmarks).source(:post) }
    # フォロー機能に対するアソシエーションテスト
    it { should have_many(:active_relationships).class_name("Relationship").with_foreign_key("follower_id").dependent(:destroy) }
    it { should have_many(:passive_relationships).class_name("Relationship").with_foreign_key("followed_id").dependent(:destroy) }
    it { should have_many(:following).through(:active_relationships).source(:followed) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }
    # 通知機能に対するアソシエーションテスト
    it { should have_many(:active_notifications).class_name("Notification").with_foreign_key("visitor_id").dependent(:destroy) }
    it { should have_many(:passive_notifications).class_name("Notification").with_foreign_key("visited_id").dependent(:destroy) }
    # 問い合わせ機能に対するアソシエーションテスト
    it { should have_many(:inquiries).dependent(:destroy) }
  end


 # バリデーションのテスト
  describe 'validations' do
    it 'is valid with a valid email, name, and password' do
      user = User.new(email: 'test@example.com', name: 'Test User', password: 'password')
      expect(user).to be_valid
    end
    
    # emailの存在性の検証
    it 'is invalid without an email' do
      user = User.new(email: nil, password: 'password', name: 'Test User')
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    # emailの形式の検証（正規表現に一致するか）
    it 'is invalid with an incorrect email format' do
      user = User.new(email: 'invalid-email', password: 'password', name: 'Test User')
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です")
    end
    
    # emailが重複しないことの検証
    it 'is invalid with a duplicate email' do
      User.create(email: 'test@example.com', password: 'password', name: 'Test User')
      user = User.new(email: 'test@example.com', password: 'password', name: 'Test User')
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end
  
    # passwordの長さの検証（６文字以上か）
    it 'is invalid with a password less than 6 characters' do
      user = User.new(email: 'test@example.com', password: 'short', name: 'Test User')
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end
    
    # nameの存在性の検証
    it 'is invalid without a name' do
      user = User.new(email: 'test@example.com', password: 'password', name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end
    
    # nameの長さの検証
    it 'is invalid with a name longer than 15 characters' do
      user = User.new(email: 'test@example.com', password: 'password', name: 'a' * 16)
      user.valid?
      expect(user.errors[:name]).to include("は15文字以内で入力してください")
    end
    
    # active スコープが退会していない（is_deleted: false）ユーザーだけを取得することのテスト
    describe "Scopes" do
      let!(:active_user) { create(:user, is_deleted: false) }
      let!(:inactive_user) { create(:user, is_deleted: true) }
  
      it "returns only active users" do
        expect(User.active).to include(active_user)
        expect(User.active).not_to include(inactive_user)
      end
    end
    
    # Postとのアソシエーションの関連
    describe 'association with posts' do
      let(:user) { create(:user) }
      let!(:post) { create(:post, user: user) }
    
      it 'has many posts' do
        expect(user.posts).to include(post)
      end
    
      it 'deletes associated posts when deleted' do
        expect { user.destroy }.to change(Post, :count).by(-1)
      end
    end
    
    # likeとのアソシエーションの関係
    describe 'association with likes' do
      let(:user) { create(:user) }
      let!(:like) { create(:like, user: user) }
    
      it 'has many likes' do
        expect(user.likes).to include(like)
      end
    
      it 'deletes associated likes when deleted' do
        expect { user.destroy }.to change(Like, :count).by(-1)
      end
    end
    
    # コメントとのアソシエーションの関係
    describe 'association with comments' do
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, user: user) }
    
      it 'has many comments' do
        expect(user.comments).to include(comment)
      end
    
      it 'deletes associated comments when deleted' do
        expect { user.destroy }.to change(Comment, :count).by(-1)
      end
    end
    
    # bookmarkとのアソシエーションの関係
    describe 'association with bookmarks' do
      let(:user) { create(:user) }
      let!(:bookmark) { create(:bookmark, user: user) }
    
      it 'has many bookmarks' do
        expect(user.bookmarks).to include(bookmark)
      end
    
      it 'deletes associated bookmarks when deleted' do
        expect { user.destroy }.to change(Bookmark, :count).by(-1)
      end
    end


  end
  
  describe 'methods' do
    # メソッドのテスト
    let(:user) { create(:user) }
    let(:other_user) { create(:user, email: "test@sample.com") }
    let!(:public_post) { create(:post, user: other_user, is_public: true) }
    let!(:private_post) { create(:post, user: other_user, is_public: false) }
    let!(:like) { create(:like, user: user, post: public_post) }
    let!(:bookmark) { create(:bookmark, user: user, post: public_post) }
  
    describe '#follow' do
      it 'follows another user' do
        user.follow(other_user)
        expect(user.following).to include(other_user)
      end
    end
  
    describe '#unfollow' do
      it 'unfollows another user' do
        user.follow(other_user)
        user.unfollow(other_user)
        # フォローがカウントが０
        expect(user.following.count).to eq(0)
      end
    end
    
  # メソッドが非公開の投稿や退会済みのユーザーの投稿を除外して、「いいね」の総数を正確にカウントすることのテスト
    it "counts the number of active liked posts" do
      expect(user.active_liked_posts_count).to eq(1)
    end
  # メソッドが非公開の投稿や退会済みのユーザーの投稿を除外して、「ブックマーク」の総数を正確にカウントすることのテスト
    it "counts the number of active bookmarked posts" do
      expect(user.active_bookmarked_posts_count).to eq(1)
    end
  end
end
