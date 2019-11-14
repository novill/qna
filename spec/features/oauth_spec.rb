require 'rails_helper'

feature 'User register with Oauth Provider',%q{
  In order to be able to ask questions
  As an non-registered User
  I want to be able to register with social network sites
} do
  given(:user) {build(:user)}



  context 'Non-registered user tries to sign in with' do
    background do
      visit new_user_session_path
      mock_auth_hash
    end

    ['GitHub', 'Digitalocean'].each do |provider|
      scenario provider do
        click_link "Sign in with #{provider}"
        # Devise в одном месте пишет GitHub в другом Github
        expect(page.body).to match(%r{Successfully authenticated from #{provider} account.}i)
        expect(current_path).to eq root_path
      end
    end
  end

  scenario 'Non-registered user fails to sign in with github' do
    visit new_user_session_path
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_link "Sign in with GitHub"

    expect(page.body).to match(%r{Could not authenticate you from GitHub}i)
  end
end