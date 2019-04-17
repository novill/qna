require 'rails_helper'

feature 'Logget user can sign out', %q{
  In order to end session
  As an logged user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Logged user tries to sign out' do
    sign_in(user)
    visit questions_path
    # save_and_open_page

    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end

end