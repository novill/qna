FactoryBot.define do
  factory :question do
    sequence(:title) { |i| "MyString #{i}" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
