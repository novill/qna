FactoryBot.define do

  factory :link do
    linkable { create(:question) }
    name { 'test link' }
    url { 'http://example.com/test' }
  end

  factory :gist_link, parent: :link do
    url { 'https://gist.github.com/novill/ca4a01934576cc036c49b2faa2900f3c' }
  end
end
