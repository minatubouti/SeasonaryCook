require 'rails_helper'

RSpec.describe Post, type: :model do
 let(:user) { create(:user) } 
 
# アソシエーションのテスト
 describe "アソシエーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_users).through(:likes).source(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:bookmarks).dependent(:destroy) }
    it { is_expected.to have_many(:bookmarked_users).through(:bookmarks).source(:user) }
    it { is_expected.to have_many(:recipe_steps).dependent(:destroy) }
    it { is_expected.to have_many(:ingredients).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  # バリデーションのテスト
  describe 'バリデーション' do
    context '必要な属性がすべて存在する場合' do
      it 'タイトル、主要野菜、季節、および公開状態が存在する場合は投稿可能' do
        post = build(:post, user: user, title: 'Delicious Salad', main_vegetable: 'Lettuce', season: '夏', is_public: true)
        expect(post).to be_valid
      end
    end
    
    # タイトルが存在しない場合のテスト
    context '必要な属性が存在しない場合' do
      it 'タイトルが存在しない場合は投稿できない' do
        post = build(:post, user: user, title: nil)
        post.valid?
        expect(post.errors[:title]).to include("を入力してください")
      end
      
    # 主要野菜が存在しない場合のテスト
      it 'メイン野菜が存在しない場合は投稿できない' do
        post = build(:post, user: user, main_vegetable: nil)
        post.valid?
        expect(post.errors[:main_vegetable]).to include("を入力してください")
      end
      
    # 季節が存在しない場合のテスト
      it '季節が選択されていない場合は投稿できない' do
        post = build(:post, user: user, season: nil)
        post.valid?
        expect(post.errors[:season]).to include("を入力してください")
      end
    end
   
  # is_publicの値がtrueまたはfalseでない場合のテスト
    # is_publicをnilに設定し、バリデーションエラーが発生することを確認します。
    context '非公開状態値の場合' do
      it 'trueまたはfalse以外の値では無効' do
        post = build(:post, user: user, is_public: nil)
        post.valid?
        expect(post.errors[:is_public]).to include("は一覧にありません")
      end
    end
    
  # 季節が指定された選択肢からのみ選べるテスト
    context '無効な季節値の場合' do
      it 'SEASONSに含まれていない季節は無効' do
        post = build(:post, user: user, season: '春夏秋冬') 
        post.valid?
        expect(post.errors[:season]).to include("は一覧にありません")
      end
    end
  end
  
    
  # recentスコープのテスト(最新の投稿を取得するもの)
    describe 'スコープ' do
      let!(:old_post) { create(:post, created_at: 1.week.ago) }
      let!(:new_post) { create(:post, created_at: 1.day.ago) }
    
      it 'oldestスコープで正しい順序で投稿を返す' do
        expect(described_class.oldest).to eq([old_post, new_post])
      end
    end

    
  # popularスコープのテスト(いいね」の多い投稿を取得するもの)
    it 'popular（いいね並び替え）スコープで正しい順序で投稿を返す' do
      popular_post = create(:post)
      unpopular_post = create(:post)
      create_list(:like, 5, post: popular_post)
    
      expect(described_class.popular).to eq([popular_post, unpopular_post])
    end
    
  # oldestスコープのテスト(最も古い投稿を取得するもの)
    describe '投稿' do
      let(:old_post) { create(:post, created_at: 2.days.ago) }
      let(:new_post) { create(:post, created_at: 1.day.ago) }
    
      it 'oldest（古い順に並び替え）スコープで正しい順序で投稿を返す' do
        expect(described_class.oldest).to eq([old_post, new_post])
      end
    end
      


  # get_imageメソッドのテスト
  # 画像が添付されている場合はその画像を、添付されていない場合はデフォルト画像を返すことをテストする
    describe '画像投稿' do
    let(:post) { create(:post) }
  
    context '投稿画像がある場合' do
      before do
        post.image.attach(io: File.open('spec/fixtures/sample_image.jpeg'), filename: 'sample_image.jpeg')
      end
  
      it '投稿画像が表示される' do
        expect(post.get_image).to eq(post.image)
      end
    end
  
    context '投稿画像がない場合' do
      it 'デフォルト画像が表示される' do
        expect(post.get_image.filename.to_s).to eq('default-image.jpg')
      end
    end
    
    # likes_by?メソッド
    describe 'likes_by?' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
    
      it 'ユーザーが投稿をいいねしていればtrueを返す' do
        create(:like, user: user, post: post)
        expect(post).to be_likes_by(user)
      end
    
      it 'ユーザーが投稿をいいねしていなければfalseを返す' do
        expect(post).not_to be_likes_by(user)
      end
    end

    # bookmarked_by? メソッド
    describe 'bookmarked_by?' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      
      it 'ユーザーが投稿をブックマークしていればtrueを返す' do
        create(:bookmark, user: user, post: post)
        expect(post).to be_bookmarked_by(user)
      end
    
      it 'ユーザーが投稿をブックマークしていなければfalseを返す' do
        expect(post).not_to be_bookmarked_by(user)
      end
    end
    
    # 通知関連のメソッド
    describe 'create_notification_like!' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      let(:comment) { create(:comment, post: post, user: user) } # コメントのインスタンスを作成
    
      describe 'いいねに関する通知' do
        it 'いいねの通知を作成する' do
          expect { post.create_notification_like!(user) }.to change(Notification, :count).by(1)
        end
      
        it '通知のアクションが"like"であること' do
          post.create_notification_like!(user)
          expect(Notification.last.action).to eq 'like'
        end
      end
    end
    
    describe 'create_notification_comment!' do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      let(:comment) { create(:comment, post: post, user: user) } 
    
      it 'コメントの通知を作成する' do
        expect { post.create_notification_comment!(user, comment.id) }.to change(Notification, :count).by(1)
        expect(Notification.last.action).to eq 'comment'
      end
    end
  end
end
