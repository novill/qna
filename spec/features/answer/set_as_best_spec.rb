require 'rails_helper'

feature 'Set best answer', %q{
  In order to mark the best answer to my quation
  As an question author
  I want to be able to mark the best answer and it will be first in answer's list
} do
  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given!(:first_answer) { create(:answer, body: 'first answer body', question: question) }

  scenario 'Question author can mark best answer', :js do
    sign_in(question_author)
    visit question_path(question)
    click_on 'Mark as best'
    expect(page).not_to have_content 'Mark as best'
    expect(page).to have_content 'Best answer'
  end


  context 'after one answer choosen as best' do
    given!(:second_answer) { create(:answer, body: 'second answer body', question: question) }
    before do
      first_answer.set_as_best
      sign_in(question_author)
    end

    scenario 'Question author can change best answer', :js do
      visit question_path(question)
      within("#answer-#{second_answer.id}") do
        click_on 'Mark as best'
        expect(page).not_to have_content 'Mark as best'
        expect(page).to have_content 'Best answer'
      end
      within("#answer-#{first_answer.id}") do
        expect(page).to have_content 'Mark as best'
        expect(page).not_to have_content 'Best answer'
      end
    end

    scenario 'new best answer placed on the first position', :js do
      visit question_path(question)
      expect(page.body.index(first_answer.body)).to be < page.body.index(second_answer.body)
      within("#answer-#{second_answer.id}") do
        click_on 'Mark as best'
      end
      sleep(1)
      expect(page.body.index(first_answer.body)).to be > page.body.index(second_answer.body)
    end

  end



  scenario 'Another authenticated user can\'t set best answer' do
    sign_in(create(:user))
    visit question_path(question)
    expect(page).not_to have_content 'Mark as best'
  end

  scenario 'Quest can\'t set best answer' do
    visit question_path(question)
    expect(page).not_to have_content 'Mark as best'
  end

end