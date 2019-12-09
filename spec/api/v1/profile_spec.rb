require 'rails_helper'

describe 'Profiles API', type: :request do

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      before {
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: api_headers
      }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/others' }
    end

    context 'authorized' do
      let!(:other_users) { create_list(:user, 2) }

      before {
        get '/api/v1/profiles/others', params: { access_token: access_token.token }, headers: api_headers
      }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of all other users' do
        expect(json['users'].size).to eq(other_users.size)
      end

      it 'return correct data' do
        json['users'].each do |response_user|
          user = other_users.select{|user| user.id == response_user['id'] }[0]

          # не получается вытащить этот кусок в shared, нельзя использовать json вне examples
          %w[id email admin created_at updated_at].each do |attr|
            expect(response_user[attr]).to eq user.send(attr).as_json
          end

          %w[password encrypted_password].each do |attr|
            expect(response_user).to_not have_key(attr)
          end
        end
      end
    end
  end
end