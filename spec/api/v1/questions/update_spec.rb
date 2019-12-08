require 'rails_helper'

describe 'Questions API', type: :request do

  describe 'Update question PATCH /api/v1/questions/:id' do
    let(:question) { create( :question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:headers) { api_form_headers }
    end

    context 'authorized' do
      context 'author' do
        let(:author) { question.user }
        let(:access_token) {create(:access_token, resource_owner_id: author.id) }
        it_behaves_like 'Mighty user update question'
      end

      context 'admin' do
        let(:admin) { create(:user, admin: true) }
        let(:access_token) {create(:access_token, resource_owner_id: admin.id) }
        it_behaves_like 'Mighty user update question'
      end

      context 'another user' do
        let(:another_user) { create(:user, admin: false) }
        let(:another_access_token) {create(:access_token, resource_owner_id: another_user.id) }
        let(:another_params) {
          {
              id: question.id,
              access_token: another_access_token.token,
              question: {
                  title: 'some_new_title',
                  body: 'some_new_body'
              }
          }
        }

        before {
          patch "/api/v1/questions/#{question.id}", params: another_params, headers: api_form_headers
        }

        it 'return not successful status' do
          expect(response.status).to eq 403
        end

        it 'does not update question' do
          question.reload
          expect(question.title).not_to eq('some_new_title')
          expect(question.body).not_to eq('some_new_body')
        end
      end
    end
  end
end
