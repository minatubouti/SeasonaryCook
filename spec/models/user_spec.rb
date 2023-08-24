require 'rails_helper'

RSpec.describe User, type: :model do
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
  end
end
