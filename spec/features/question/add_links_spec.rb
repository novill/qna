require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/novill/ca4a01934576cc036c49b2faa2900f3c' }

  scenario 'User adds gist link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Question title', with: 'Test question'
    fill_in 'Question body', with: 'text text text'


    click_on 'Add link'

    fill_in 'Link name', with: 'My gist1'
    fill_in 'Url', with: gist_url

    expect(page).to have_link 'Add link'

    click_on 'Ask'

    expect(page).to have_content 'Test gist body 1'
  end

  scenario 'User adds non-gist link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Question title', with: 'Test question'
    fill_in 'Question body', with: 'text text text'


    click_on 'Add link'

    fill_in 'Link name', with: 'My test url'
    fill_in 'Url', with: 'http://example.com'

    expect(page).to have_link 'Add link'

    click_on 'Ask'

    expect(page).to have_link 'My test url', href: 'http://example.com'
  end

  scenario 'User tries to add bad link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Question title', with: 'Test question'
    fill_in 'Question body', with: 'text text text'


    click_on 'Add link'

    fill_in 'Link name', with: 'My gist1'
    fill_in 'Url', with: 'foo'

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end
end