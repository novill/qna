require 'rails_helper'

describe 'Answers API', type: :request do
  let(:method) { :post }
  let(:question) { create(:question) }
  describe 'Create answer POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { api_form_headers }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      it 'creates valid answer' do
        params = {
          access_token: access_token.token,
          question_id: question.id,
          answer: {
            body: 'some_body'
          }
        }
        post api_path, params: params, headers: api_form_headers
        expect(response).to be_successful
        expect(json['answer']['body']).to eq('some_body')

        created_answer = Answer.find(json['answer']['id'])
        expect(created_answer.question_id).to eq(question.id)
        expect(created_answer.body).to eq('some_body')
        expect(created_answer.user_id).to eq(access_token.resource_owner_id)
      end

      it 'does not create invalid answer' do
        params = {
          access_token: access_token.token,
          question_id: question.id,
          answer: {
             body: nil
          }
        }
        post api_path, params: params, headers: api_form_headers
        expect(response).not_to be_successful
      end
    end
  end
end

