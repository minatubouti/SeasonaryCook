# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create!(
  [
    {email: 'olivia@example.com', name: 'Olivia', password: 'password'},
    {email: 'james@example.com', name: 'James', password: 'password'},
    {email: 'lucas@example.com', name: 'Lucas', password: 'password'}
  ]
)

users = User.all

posts = [
  { title: '蒸し野菜', main_vegetable: 'ブロッコリー', season: '春', is_public: true, description: 'ヘルシーで栄養たっぷり！', user_id: users[0].id },
  { title: '野菜たっぷりポトフ', main_vegetable: 'キャベツ', season: '冬', is_public: true, description: '体の芯から温まる', user_id: users[1].id },
  { title: '蓮根と夏野菜あんかけ', main_vegetable: '蓮根', season: '夏', is_public: true, description: '野菜たっぷりで美味しい！', user_id: users[2].id }
]

images = [
  "#{Rails.root}/db/fixtures/sample-post1.jpg",
  "#{Rails.root}/db/fixtures/sample-post2.jpg",
  "#{Rails.root}/db/fixtures/sample-post3.png"
]

posts.each_with_index do |post_data, index|
  post = Post.create!(post_data)
  image_blob = ActiveStorage::Blob.create_and_upload!(io: File.open(images[index]), filename: File.basename(images[index]))
  post.image.attach(image_blob)
end
