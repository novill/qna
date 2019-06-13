require 'rails_helper'

feature 'Vote for question' do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'Authenticated user can upvote for good question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      expect(page).to have_link('Up')
      expect(page).to have_link('Down')
      click_on "Up"
      expect(page).not_to have_link('Up')
      expect(page).not_to have_link('Down')
      expect(page).to have_link('Vote back')
      expect(page).to have_content('Rating 1')
    end
  end

  scenario 'Authenticated user can downvote for bad question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      expect(page).to have_link('Up')
      expect(page).to have_link('Down')
      click_on "Down"
      expect(page).not_to have_link('Up')
      expect(page).not_to have_link('Down')
      expect(page).to have_link('Vote back')
      expect(page).to have_content('Rating -1')
    end
  end

  scenario 'Authenticated user can take his vote back', js: true do
    question.upvote(user)
    sign_in(user)

    visit question_path(question)
    within '.question' do
      expect(page).to have_link('Vote back')
      click_on "Vote back"
      expect(page).to have_link('Up')
      expect(page).to have_link('Down')
      expect(page).not_to have_link('Vote back')
      expect(page).to have_content('Rating 0')
    end
  end

  scenario "Author can' vote for his question", js: true do
    sign_in(question.user)
    visit question_path(question)
    within '.question' do
      expect(page).not_to have_link('Up')
      expect(page).not_to have_link('Down')
    end
  end
end
