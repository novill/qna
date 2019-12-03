FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken'  do
    association :application, factory: :oauth_application
    resource_owner_id { create(:user, admin: true).id }
    expires_in { 86400 }
    scopes { "public" }
  end
end