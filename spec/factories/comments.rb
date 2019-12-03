FactoryBot.define do
  factory :comment do
    sequence(:body) { |i| "comment body #{i}" }
    user { create(:user) }
  end
end
