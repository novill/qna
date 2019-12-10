require 'rails_helper'

describe 'Questions API', type: :request do
  describe 'Create question POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { api_form_headers }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      it 'creates valid question' do
        params = {
          access_token: access_token.token,
          question: {
            title: 'some_title',
            body: 'some_body'
          }
        }
        post api_path, params: params, headers: api_form_headers
        expect(response).to be_successful
        expect(json['question']['title']).to eq('some_title')
        expect(json['question']['body']).to eq('some_body')
        created_question = Question.find(json['question']['id'])
        expect(created_question.title).to eq('some_title')
        expect(created_question.body).to eq('some_body')
        expect(created_question.user_id).to eq(access_token.resource_owner_id)
      end

      it 'does not create invalid question' do
        params = {
            access_token: access_token.token,
            question: {
                title: nil,
                body: nil
            }
        }
        post api_path, params: params, headers: api_form_headers
        expect(response).not_to be_successful
      end
    end
  end
end

