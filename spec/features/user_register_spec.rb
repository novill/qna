require 'rails_helper'

feature 'User register',%q{
  In order to be able to ask questions
  As an non-registered User
  I want to be able to register
} do
  given(:user) {build(:user)}

  scenario 'Non-registered user try to register' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content ' You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in with github' do
    visit new_user_session_path
    expect(page).to have_link'Sign in with GitHub'
    mock_auth_hash
    click_link 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in with Digitalocean' do
    visit new_user_session_path
    expect(page).to have_link'Sign in with Digitalocean'
    mock_auth_hash
    click_link 'Sign in with Digitalocean'
    expect(page).to have_content 'Successfully authenticated from Digitalocean account.'
    expect(current_path).to eq root_path
  end
end