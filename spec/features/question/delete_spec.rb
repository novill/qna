require 'rails_helper'

feature 'Delete question', %q{
  In order to delete wrong question
  As an author
  I want to be able to delete my question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:my_question) { create(:question, :with_file, user: author) }
  given(:my_question_with_link) { create(:question, :with_link, user: author) }
  context 'Authenticated author ' do
    before { sign_in(author) }

    scenario 'deletes question' do
      visit question_path(my_question)
      click_on 'Delete question'
      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).not_to have_content my_question.title
      expect(page).to have_current_path(questions_path)
    end

    scenario 'deletes file of question' do
      visit question_path(my_question)
      expect(page).to have_content my_question.files[0].filename.to_s
      click_on 'X'
      expect(page).not_to have_content my_question.files[0].filename.to_s
    end

    scenario 'deletes link to his question' do
      visit question_path(my_question_with_link)
      expect(page).to have_content my_question_with_link.links[0].name
      click_on 'X'
      expect(page).to_not have_content my_question_with_link.links[0].name
    end
  end

  context "Authenticated user, not author " do
    before do
      sign_in(user)
      visit question_path(my_question)
    end

      scenario "can't see 'Delete question' link" do
        expect(page).not_to have_content 'Delete question'
      end

    scenario 'deletes link to another question' do
      expect(page).to_not have_link 'X'
    end
  end

  scenario "Guest can't see 'Delete question' link" do
    visit question_path(my_question)
    expect(page).not_to have_link 'Delete answer'
  end
end