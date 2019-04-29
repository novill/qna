require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove wrong answer
  As an author
  I want to be able to delete my answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:my_answer) { create(:answer, question: question, user: author) }

  scenario 'Authenticated author deletes answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).not_to have_content my_answer.body
    expect(page).to have_current_path question_path(question)
  end

  scenario "Authenticated user, not author, can't see 'Delete answer' link" do
    sign_in(user)
    visit question_path(question)
    expect(page).not_to have_link 'Delete answer'
  end
  #
  scenario "Guest can't see 'Delete answer' link" do
    visit question_path(question)
    expect(page).not_to have_link 'Delete answer'
  end
end