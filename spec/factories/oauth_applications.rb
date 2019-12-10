FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    uid { '12345678' }
    secret { '876543212' }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    scopes  { "" }
    confidential { true }
  end
end