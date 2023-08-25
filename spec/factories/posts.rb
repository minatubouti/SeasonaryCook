FactoryBot.define do
# schem.rbにnull: falseを指定しているカラムは全て必要
  factory :post do
    title { 'Test Title' }
    description { 'Test Description' }
    main_vegetable { 'Test Main_vegetable' }
    season { '春' }
    is_public { true }
     association :user # Userとの関連付け
  end
end
