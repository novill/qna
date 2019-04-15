require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "POST #create" do
    context 'authenticated user' do
      before { login(user) }
      context 'with correct params' do
        it 'saves a new answer for question in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to question
        end
      end

      context 'with incorrect params' do
        it 'doest not saves a new answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
        end

        it 'render question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'not authenticated user' do
      it 'does not save new answer for question to the database' do
        expect { post :create, params: {question_id: question.id, answer: attributes_for(:answer)} }.not_to change(Answer, :count)
      end
    end
  end

end
