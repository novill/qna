require 'rails_helper'

feature 'Delete question', %q{
  In order to delete wrong question
  As an author
  I want to be able to delete my question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:my_question) { create(:question, user: author) }

  scenario 'Authenticated author deletes question' do
    sign_in(author)
    visit question_path(my_question)
    click_on 'Delete question'
    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).not_to have_content my_question.title
    expect(page).to have_current_path(questions_path)
  end

  scenario 'Authenticated user, not author, can\'t see \'Delete question\' link' do
    sign_in(user)
    visit question_path(my_question)
    expect(page).not_to have_content 'Delete question'
  end
  #
  scenario 'Guest can\'t see \'Delete question\' link' do
    visit question_path(my_question)
    expect(page).not_to have_link 'Delete answer'
  end
end