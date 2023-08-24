FactoryBot.define do
  factory :comment do
    association :user 
    association :post 
    content { "コメント内容" }
  end
end
