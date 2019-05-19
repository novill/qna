require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove wrong answer
  As an author
  I want to be able to delete my answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated author ' do
    given!(:my_answer) { create(:answer, :with_file, question: question, user: author) }
    before { sign_in(author) }

    scenario 'deletes answer', js: true do
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).not_to have_content my_answer.body
      expect(page).to have_current_path question_path(question)
    end

    scenario 'Authenticated author deletes file of answer' do
      visit question_path(question)
      expect(page).to have_content my_answer.files[0].filename.to_s
      click_on 'X'
      expect(page).not_to have_content my_answer.files[0].filename.to_s
    end

    scenario 'deletes link to his answer' do
      question_for_link =  create(:question)
      my_answer_with_link = create(:answer, :with_link, question: question_for_link, user: author)
      visit question_path(question_for_link)
      expect(page).to have_content my_answer_with_link.links[0].name
      click_on 'X'
      expect(page).to_not have_content my_answer_with_link.links[0].name
    end
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


  scenario 'deletes link to another answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'X'
  end
end