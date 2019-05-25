require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let!(:my_answer) {create :answer, body: 'answer body 1', question: question, user: user}

  describe "POST #create" do
    context 'authenticated user' do
      before { login(user) }
      context 'with correct params' do
        it 'saves a new answer for question in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'assings a new answer for author in the database' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(user).to be_author_of(assigns(:answer))
        end

        it 'redirects to question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with incorrect params' do
        it 'doest not saves a new answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
        end

        it 'render create' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
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
        expect { delete :destroy, params: {id: answer.id}, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'render destroy' do
        login(author)
        delete :destroy, params: {id: answer.id}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      it "can't delete question" do
        login(user)
        expect { delete :destroy, params: {id: answer.id}, format: :js}.not_to change(Answer, :count)
      end
    end

    context 'guest' do
      it "can't delete question" do
        expect { delete :destroy, params: {id: answer.id}, format: :js}.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: author) }
    context 'author' do
      before { login(author) }
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not author' do
      before { login(create(:user)) }
      it "can't change answer attributes" do
        expect{patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js}.not_to change(answer, :body)
      end
    end

    context 'guest' do
      it "can't change answer attributes" do
        expect{patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js}.not_to change(answer, :body)
      end
    end
  end

  describe "POST #set_as_best" do
    context "with question author" do
      before { login(question.user) }

      it "sets best flag" do
        post :set_as_best, params: {id: my_answer }, format: :js
        my_answer.reload
        expect(my_answer).to be_best
      end

      it 'assigns reward to user' do
        reward = create(:reward, question: question)
        patch :set_as_best, params: {id: my_answer}, format: :js
        expect{reward.reload}.to change(reward, :user).from(nil).to(my_answer.user)
      end

      it "renders set_as_best template" do
        post :set_as_best, params: {id: my_answer }, format: :js
        expect(response).to render_template :set_as_best
      end
    end

    context "with other user" do
      before { login(create :user) }
      it "does not set best flag" do
        post :set_as_best, params: {id: my_answer }, format: :js
        my_answer.reload
        expect(my_answer).to_not be_best
      end
    end
  end

end
