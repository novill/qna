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
end