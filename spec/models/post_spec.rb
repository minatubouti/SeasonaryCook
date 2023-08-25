require 'rails_helper'

RSpec.describe Post, type: :model do
 let(:user) { create(:user) } 

  # バリデーションのテスト
  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid with a title, main_vegetable, season, and is_public' do
        post = build(:post, user: user, title: 'Delicious Salad', main_vegetable: 'Lettuce', season: '夏', is_public: true)
        expect(post).to be_valid
      end
    end
    
    # タイトルが存在しない場合のテスト
    context 'without necessary attributes' do
      it 'is invalid without a title' do
        post = build(:post, user: user, title: nil)
        post.valid?
        expect(post.errors[:title]).to include("を入力してください")
      end
      
    # 主要野菜が存在しない場合のテスト
      it 'is invalid without a main_vegetable' do
        post = build(:post, user: user, main_vegetable: nil)
        post.valid?
        expect(post.errors[:main_vegetable]).to include("を入力してください")
      end
      
    # 季節が存在しない場合のテスト
      it 'is invalid without a season' do
        post = build(:post, user: user, season: nil)
        post.valid?
        expect(post.errors[:season]).to include("を入力してください")
      end
    end
   
  # is_publicの値がtrueまたはfalseでない場合のテスト
    # is_publicをnilに設定し、バリデーションエラーが発生することを確認します。
    context 'with invalid is_public value' do
      it 'is invalid with a value other than true or false' do
        post = build(:post, user: user, is_public: nil)
        post.valid?
        expect(post.errors[:is_public]).to include("は一覧にありません")
      end
    end
    
  # 季節が指定された選択肢からのみ選べるテスト
    context 'with invalid season value' do
      it 'is invalid with a season not included in SEASONS' do
        post = build(:post, user: user, season: '春夏秋冬') 
        post.valid?
        expect(post.errors[:season]).to include("は一覧にありません")
      end
    end
  end
  
  # アソシエーションのテスト
  
  # Postモデルが多数のlikesを持つことを確認するテスト
    describe 'associations' do
      it 'has many likes' do
        expect(Post.reflect_on_association(:likes).macro).to eq(:has_many)
      end
    end
    
  # Postモデルが多数のliked_usersを持つことを確認するテスト
    it 'has many liked_users' do
      expect(Post.reflect_on_association(:liked_users).macro).to eq(:has_many)
    end
    
  # Postモデルが多数のcommentsを持つことを確認するテスト
    it 'has many comments' do
      expect(Post.reflect_on_association(:comments).macro).to eq(:has_many)
    end
    
  # Postモデルが多数のbookmarksを持つことを確認するテスト
    it 'has many bookmarks' do
      expect(Post.reflect_on_association(:bookmarks).macro).to eq(:has_many)
    end
    
  # Postモデルが多数のrecipe_steps(作り方)を持つことを確認するテスト
    it 'has many recipe_steps' do
      expect(Post.reflect_on_association(:recipe_steps).macro).to eq(:has_many)
    end
    
  # Postモデルが多数のingredients(材料)を持つことを確認
    it 'has many ingredients' do
      expect(Post.reflect_on_association(:ingredients).macro).to eq(:has_many)
    end
    
  # Postモデルが多数のnotifications(通知)を持つことを確認するテスト
    it 'has many notifications' do
      expect(Post.reflect_on_association(:notifications).macro).to eq(:has_many)
    end
    
    
  # recentスコープのテスト(最新の投稿を取得するもの)
    describe 'scopes' do
      let!(:old_post) { create(:post, created_at: 1.week.ago) }
      let!(:new_post) { create(:post, created_at: 1.day.ago) }
    
      it 'returns posts in the correct order for oldest scope' do
        expect(Post.oldest).to eq([old_post, new_post])
      end
    end

    
  # popularスコープのテスト(いいね」の多い投稿を取得するもの)
    it 'returns posts in the correct order for popular scope' do
      popular_post = create(:post)
      unpopular_post = create(:post)
      create_list(:like, 5, post: popular_post)
    
      expect(Post.popular).to eq([popular_post, unpopular_post])
    end
    
  # oldestスコープのテスト(最も古い投稿を取得するもの)
    describe 'Post' do
      let(:old_post) { create(:post, created_at: 2.days.ago) }
      let(:new_post) { create(:post, created_at: 1.day.ago) }
    
      it 'returns posts in the correct order for oldest scope' do
        expect(Post.oldest).to eq([old_post, new_post])
      end
    end
      


  # get_imageメソッドのテスト
  # 画像が添付されている場合はその画像を、添付されていない場合はデフォルト画像を返すことをテストする
    describe 'get_image' do
    let(:post) { create(:post) }
  
    context 'when image is attached' do
      before do
        post.image.attach(io: File.open('spec/fixtures/sample_image.jpeg'), filename: 'sample_image.jpeg')
      end
  
      it 'returns the attached image' do
        expect(post.get_image).to eq(post.image)
      end
    end
  
    context 'when image is not attached' do
      it 'returns the default image' do
        expect(post.get_image).to eq('path/to/default_image.jpg')
      end
    end
    
    # likes_by?メソッド
    describe 'likes_by?' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
    
      it 'returns true if the user likes the post' do
        create(:like, user: user, post: post)
        expect(post.likes_by?(user)).to be_truthy
      end
    
      it 'returns false if the user does not like the post' do
        expect(post.likes_by?(user)).to be_falsey
      end
    end
    # bookmarked_by? メソッド
    describe 'bookmarked_by?' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      
      it 'returns true if the user likes the post' do
        create(:bookmark, user: user, post: post)
        expect(post.bookmarked_by?(user)).to be_truthy
      end
    
      it 'returns false if the user does not like the post' do
        expect(post.bookmarked_by?(user)).to be_falsey
      end
    end
    
    # 通知関連のメソッド
    describe 'create_notification_like!' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      let(:comment) { create(:comment, post: post, user: user) } # コメントのインスタンスを作成
    
      it 'creates a notification for like' do
        expect { post.create_notification_like!(user) }.to change(Notification, :count).by(1)
        expect(Notification.last.action).to eq 'like'
      end
    end
    
    describe 'create_notification_comment!' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      let(:comment) { create(:comment, post: post, user: user) } 
    
      it 'creates a notification for comment' do
        expect { post.create_notification_comment!(user, comment.id) }.to change(Notification, :count).by(1)
        expect(Notification.last.action).to eq 'comment'
      end
    end
    
    describe 'save_notification_comment!' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      let(:comment) { create(:comment, post: post, user: user) }
    
      it 'creates a notification for comment' do
        expect { post.create_notification_comment!(user, comment.id) }.to change(Notification, :count).by(1)
        expect(Notification.last.action).to eq 'comment'
      end
    end
  end

end
