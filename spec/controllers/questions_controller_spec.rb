require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }


    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:answers) { create_list(:answer, 2, question: question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'build new answer ' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    context 'author' do
      before { login(author) }
      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'not author' do
      it 'redirect_to question view' do
        login(user)
        get :edit, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assings new question to author' do
        post :create, params: {question: attributes_for(:question)}
        # expect(author.author_of?(Question.last)).to be
        expect { post :create, params: {question: attributes_for(:question)} }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'author' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'autenticated user, but not author' do
      before { login(user) }

      let!(:question) { create(:question) }

      it "can't delete the question" do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'guest' do
      let!(:question) { create(:question) }

      it "can't delete the question" do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'author' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }

      context 'with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: {title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render update' do
          patch :update, params: { id: question, question: {title: 'new title', body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'Don\'t change question attributes' do
          old_title = question.title
          old_body = question.body
          patch :update, params: { id: question, question: {title: nil, body: nil } }, format: :js
          question.reload
          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end
      end
    end
    context 'not author' do
      before { login(user) }
      let!(:question) { create(:question) }

      context 'with valid attributes' do
        it "don't changes question attributes" do
          old_title = question.title
          old_body = question.body
          patch :update, params: { id: question, question: {title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end
      end
    end
    context 'guest' do
      let!(:question) { create(:question) }

      context 'with valid attributes' do
        it "don't changes question attributes" do
          old_title = question.title
          old_body = question.body
          patch :update, params: { id: question, question: {title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end
      end
    end
  end
end
