require 'rails_helper'

describe 'Questions API', type: :request do

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create( :question, :with_file, :with_link) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let(:question_response) { json['question'] }
      let!(:comments) { create_list( :comment, 2, commentable: question) }
      let(:comments_response) { question_response['comments'] }
      let(:attachments) { question.files }
      let(:attachments_response) { question_response['files'] }
      let(:links) { question.links }
      let(:links_response) { question_response['links'] }

      before {get api_path, params: {access_token: access_token.token}, headers: api_headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all question public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr].to_json).to eq question.send(attr).to_json
        end
      end

      it_behaves_like 'API attachable'
      it_behaves_like 'API commentable'
      it_behaves_like 'API linkable'
    end
  end
end

