require 'rails_helper'

feature 'User can see question page with answers', %q{
  In order to read question body and answers
  As an any user
  I'd like to be able to see question body and answers
} do
  given(:user) {create(:user)}
  given(:question) { create(:question)}
  given!(:answers) { create_list(:answer, 2, question: question)}

  scenario 'Authenticated user can see question page with title and body' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_link 'Subscribe'
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user can see question page with title and body' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).not_to have_link 'Subscribe'
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Authenticated user can subscribe for answers', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'Authenticated user can unsubscribe for answers', js: true do
    question.subscriptions.create(user_id: user.id)
    sign_in(user)
    visit question_path(question)
    click_on 'Unsubscribe'
    expect(page).to have_link 'Subscribe'
  end

end