require 'rails_helper'

feature 'Authenticated user can write answer in question page', %q{
  In order to qive answer
  As an authenticated user
  I'd like to be able to give answer for question
} do

  given(:user) {create(:user)}
  given(:question) { create(:question)}

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'My Answer Body'
    click_on 'Create'
    within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
      expect(page).to have_content 'My Answer Body'
    end
    expect(page).to have_current_path(question_path(question))
  end

  scenario 'Authenticated user gives answer with files', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'My Answer Body'
    attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

    click_on 'Create'
    within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
    expect(page).to have_current_path(question_path(question))
  end

  scenario "Authenticated user creates answer with errors", js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create'
    expect(page).to have_content "Body can't be blank"
  end

  scenario "Non-authenticated user can't see answer form" do
    visit question_path(question)
    expect(page).not_to have_button 'Create'
  end

  context 'multiple sessions', js: true do
    let(:second_user) {create(:user)}
    scenario 'answer appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('second_user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'My Answer Body'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'My Answer Body'
          expect(page).not_to have_link('Up')
          expect(page).not_to have_link('Down')
        end
      end

      Capybara.using_session('second_user') do
        within '.answers' do
          expect(page).to have_content 'My Answer Body'
          expect(page).to have_link('Up')
          expect(page).to have_link('Down')
        end
      end
      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'My Answer Body'
          expect(page).not_to have_link('Up')
          expect(page).not_to have_link('Down')
        end
      end
    end
  end
end
