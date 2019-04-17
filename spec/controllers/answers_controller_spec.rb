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

        it 'assings a new answer for author in the database' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(user).to be_author_of(assigns(:answer))
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

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'author' do
      it 'deletes answer' do
        login(author)
        expect { delete :destroy, params: {id: answer.id}}.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        login(author)
        delete :destroy, params: {id: answer.id}
        expect(response).to redirect_to question
      end
    end

    context 'not author' do
      it "can't delete question" do
        login(user)
        expect { delete :destroy, params: {id: answer.id}}.not_to change(Answer, :count)
      end
    end

    context 'guest' do
      it "can't delete question" do
        expect { delete :destroy, params: {id: answer.id}}.not_to change(Answer, :count)
      end
    end
  end
end
