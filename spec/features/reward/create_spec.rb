require 'rails_helper'

feature 'User can create reward for best answer' do
  scenario 'Author can add reward while creating question' do
    sign_in(create(:user))
    visit new_question_path

    fill_in 'Question title', with: 'Test question'
    fill_in 'Question body', with: 'text text text'

    within '.reward' do
      fill_in 'Title', with: 'Reward'
      attach_file 'Image', "#{Rails.root}/spec/support/test-image.png"
    end
    click_on 'Ask'
    expect(page).to have_content 'Your question successfully created.'
  end
end