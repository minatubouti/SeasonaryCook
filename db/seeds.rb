# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create!(
  [
    {email: 'olivia@example.com', name: 'オリバ', password: 'password'},
    {email: 'aqua@example.com', name: 'アクア', password: 'password'},
    {email: 'momo@example.com', name: 'もも', password: 'password'}
  ]
)

users = User.all

# createでデータを保存する
 Post.create!(
  [
    
    {title: '蒸し野菜',
      main_vegetable: 'ブロッコリー',
      season: '春',
      is_public: true,
      description: 'ヘルシーで栄養たっぷり！',
      image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg"),
      user_id: users[0].id,
      # postsコントローラーで使っている accepts_nested_attributesを使用
      ingredients_attributes: [
        { name: 'ブロッコリー', amount: '100g' },
        { name: 'パプリカ', amount: '50g' },
        { name: '人参', amount: '1本' },
      ],
      # 同じくrecipe_steps_attributesを使用
      recipe_steps_attributes: [ {instructions: '材料を食べやすい大きさに切る'}, {instructions: '塩を振る'}, {instructions: '蒸し器に入れる'}, {instructions: '材料を蒸す'}, {instructions: '盛り付ける'}]
    },
      
   
    {title: '野菜たっぷりポトフ',
      main_vegetable: 'キャベツ', 
      season: '冬', 
      is_public: true, 
      description: '体の芯から温まる', 
      image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename:"sample-post2.jpg"),
      user_id: users[1].id,
      ingredients_attributes: [
        {name: '玉ねぎ', amount: '1個'},
        {name: 'キャベツ', amount: '半個'},
        {name: '人参', amount: '1本'},
        {name: 'ソーセージ', amount: '1袋'},
        {name: 'コンソメ', amount: '大さじ３'}
      ],
      recipe_steps_attributes: [{instructions: '材料を洗い、皮を剥く'}, {instructions: '材料を食べやすい大きさに切る'},{instructions: '鍋に水をいれ全ての材料を入れる'}, {instructions: '30分煮込む'},{instructions: 'コンソメを入れる'},{instructions:  '１０分煮込むと完成'}]
     },
      
   
    {title: '蓮根と夏野菜あんかけ', 
      main_vegetable: '蓮根',
      season: '夏', 
      is_public: true, 
      description: '野菜たっぷりで美味しい！', 
      image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.png"), filename:"sample-post3.png"),
      user_id: users[2].id,
      ingredients_attributes: [
        {name: '蓮根', amount: '1個'},
        {name: 'パプリカ', amount: '半個'}, 
        {name: '人参', amount: '1本'},
        {name: 'なす', amount: '100g'},
        {name: 'あんかけのタレ', amount: '適量'}
      ],
      recipe_steps_attributes: [{instructions: '材料を食べやすい大きさに切る'}, {instructions: '蓮根とにんじんを下茹でする'}, {instructions: 'フライパンで野菜を炒める'},{instructions: 'タレを入れてあんかけにする'},{instructions: '盛り付ける'}]
    }]
  )
  
  
  


