FactoryBot.define do
  factory :reward do
    sequence(:title) { |i| "My reward #{i}" }
    image { fixture_file_upload(Rails.root.join('spec/support', 'test-image.png'), 'test-image.png') }
    question
  end
end
