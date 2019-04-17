require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to find question
  As an any user
  I'd like to be able to see list of questions
} do
  given(:user) {create(:user)}
  given!(:questions) { create_list(:question, 2)}

  scenario 'Authenticated user can see list of questions' do
    sign_in(user)
    visit questions_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end

  scenario 'Unauthenticated user can see list of questions' do
    visit questions_path
    questions.each { |q| expect(page).to have_content(q.title) }
  end

end