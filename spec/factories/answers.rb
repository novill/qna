FactoryBot.define do
  factory :answer do
    sequence(:body) { |i| "MyAnswerString #{i}" }
    question { nil }
    user { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
