require 'sphinx_helper'

feature 'Search', '
  I want to be able to search for all or custom class', js:true do

  let!(:user) { create(:user, email: 'unique@test.com') }
  let!(:question) { create(:question, title: 'question_title', body: 'question_body common_body') }
  let!(:answer) { create(:answer, body: 'answer_body common_body') }
  let!(:comment) { create(:comment, body: 'comment_body common_body', commentable: question) }

  before do
    sign_in(create(:user))
    visit root_path
  end


  scenario 'Search with no matches', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'weird query'
      click_on 'Search'
      expect(page).to have_content 'No results'
    end
  end

  scenario 'Search in all classes', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'common_body'
      click_on 'Search'
      expect(page).to have_content 'question_body common_body'
      expect(page).to have_content 'answer_body common_body'
      expect(page).to have_content 'comment_body common_body'
    end
  end

  scenario 'Search in questions bodies', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'common_body'
      select 'Question', from: :search_class
      click_on 'Search'
      expect(page).to have_content 'question_title'
      expect(page).to have_content 'question_body common_body'
      expect(page).to have_content question.user.email
      expect(page).not_to have_content 'answer_body common_body'
      expect(page).not_to have_content 'comment_body common_body'
    end
  end

  scenario 'Search in questions titles', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'question_title'
      select 'Question', from: :search_class
      click_on 'Search'
      expect(page).to have_content 'question_title'
      expect(page).to have_content 'question_body common_body'
      expect(page).to have_content question.user.email
      expect(page).not_to have_content 'answer_body common_body'
      expect(page).not_to have_content 'comment_body common_body'
    end
  end

  scenario 'Search in answers', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'common_body'
      select 'Answer', from: :search_class
      click_on 'Search'
      expect(page).not_to have_content 'question_body common_body'
      expect(page).to have_content 'answer_body common_body'
      expect(page).to have_content answer.user.email
      expect(page).not_to have_content 'comment_body common_body'
    end
  end

  scenario 'Search in comments', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'common_body'
      select 'Comment', from: :search_class
      click_on 'Search'
      expect(page).not_to have_content 'question_body common_body'
      expect(page).not_to have_content 'answer_body common_body'
      expect(page).to have_content 'comment_body common_body'
      expect(page).to have_content comment.user.email

    end
  end

  scenario 'Search in users', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in :search_query, with: 'unique@test.com'
      click_on 'Search'
      expect(page).to have_content 'unique@test.com'
      expect(page).not_to have_content 'question_body common_body'
      expect(page).not_to have_content 'answer_body common_body'
      expect(page).not_to have_content 'comment_body common_body'
    end
  end
end