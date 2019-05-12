FactoryBot.define do
  factory :answer do
    sequence(:body) { |i| "MyAnswerString #{i}" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end
  end
end
