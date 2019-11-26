require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:user_question) { create( :question, user: user) }
    let(:other_question) { create( :question, user: other) }
    let(:user_answer) { create( :answer, user: user) }
    let(:other_answer) { create( :answer, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, user_question }
      it { should_not be_able_to :update, other_question }
    end

    context 'answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, user_answer }
      it { should_not be_able_to :update, other_answer }
      it { should be_able_to :set_best, create(:answer, question: user_question) }
      it { should_not be_able_to :set_best, create(:answer, question: other_question) }
    end

    context 'comment' do
      it { should be_able_to :create, Comment }
    end

    context 'vote' do
      it { should be_able_to [:upvote, :downvote], other_answer }
      it { should_not be_able_to [:upvote, :downvote, :vote_back], user_answer }
      it 'should can vote back after voting' do
        other_answer.upvote(user)
        is_expected.to be_able_to(:vote_back, other_answer)
      end
    end

    context 'attachments' do
      let(:user) { create :user }
      let(:other) { create :user }
      let(:user_question) { create( :question, user: user) }
      let(:other_question) { create( :question, user: other) }
      it { should be_able_to :destroy, user_question }
      it { should_not be_able_to :destroy, other_question }

    end
  end
end