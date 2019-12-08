require 'rails_helper'

describe 'Answers API', type: :request do
#
  describe 'DELETE /api/v1/answers/:id' do
    let(:answer) { create( :answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:headers) { api_form_headers }
    end

    context 'authorized' do
      context 'author' do
        let(:author) { answer.user }
        let(:access_token) {create(:access_token, resource_owner_id: author.id) }
        it_behaves_like 'Mighty user delete answer'
      end

      context 'admin' do
        let(:admin) { create(:user, admin: true) }
        let(:access_token) {create(:access_token, resource_owner_id: admin.id) }
        it_behaves_like 'Mighty user delete answer'
      end

      context 'another user' do
        let(:another_user) { create(:user, admin: false) }
        let(:another_access_token) {create(:access_token, resource_owner_id: another_user.id) }
        let(:another_params) {
          {
            id: answer.id,
            access_token: another_access_token.token,
          }
        }

         before { delete "/api/v1/answers/#{answer.id}", params: another_params, headers: api_form_headers }

        it 'return not successful status' do
          expect(response.status).to eq 403
        end

        it 'does not deletes question' do
          expect(Answer.find(answer.id)).to be
        end
      end
    end
  end
end
