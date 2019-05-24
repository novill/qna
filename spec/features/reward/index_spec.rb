require 'rails_helper'

feature 'Authenticated user can see his rewards ' do
  scenario 'User see rewards list' do
    question = create(:question)
    answer_author = create(:user)
    rewards = create_list(:reward, 2, question: question, user: answer_author)

    sign_in(answer_author)
    visit root_path
    click_on 'Rewards'
    rewards.each do |reward|
      expect(page).to have_content reward.title
      expect(page).to have_content reward.question.title
    end
  end
end