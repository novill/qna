require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_file, user: user) }
  let!(:answer) { create(:answer, :with_file, question: question, user: user) }
  let(:question_file) { question.files[0] }
  let(:answer_file) { answer.files[0] }

  describe 'DELETE #destroy' do
    context 'User tries to delete file on' do
      before { login(user) }
      context 'his question' do
        it 'deletes the file from question' do
          expect { delete :destroy, params: { id: question_file.id }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'redirect to question' do
          delete :destroy, params: { id: answer_file.id }, format: :js
          expect(response).to redirect_to question
        end
      end

      context 'his answer' do
        it 'deletes the file from answer' do
          expect { delete :destroy, params: { id: answer_file.id }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'redirect to question' do
          delete :destroy, params: { id: answer_file.id }, format: :js
          expect(response).to redirect_to question
        end
      end
    end

    context 'Another user tries to delete file' do
      before { sign_in(create(:user)) }

      it 'does not delete file on another question' do
        expect { delete :destroy, params: { id: question_file.id }, format: :js }.to_not change(question.files, :count)
      end

      it 'does not delete file on another question' do
        expect { delete :destroy, params: { id: answer_file.id }, format: :js }.to_not change(answer.files, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer_file.id }, format: :js
        expect(response).to redirect_to question
      end
    end
  end
end
