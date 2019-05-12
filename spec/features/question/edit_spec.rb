require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Author can edit his question', js: true do
    sign_in(user)
    visit question_path question
    click_on 'Edit question'

    fill_in 'Question title', with: 'edited question title'
    fill_in 'Question body', with: 'edited question body'
    click_on 'Save question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content 'edited question title'
    expect(page).to have_content 'edited question body'
  end

  scenario 'Author can add files while edit his question', js: true do
    sign_in(user)
    visit question_path question
    click_on 'Edit question'
    within '.question-edit' do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    end

    click_on 'Save question'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  scenario "Not author can't see edit link for question" do
    sign_in(another_user)
    visit question_path question

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Guest can't edit hit question" do
    visit question_path question

    expect(page).to_not have_link 'Edit question'
  end
end
