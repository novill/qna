FactoryBot.define do
  factory :question do
    sequence(:title) { |i| "MyString #{i}" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :with_link do
      links { [create(:link)] }
    end
  end
end
