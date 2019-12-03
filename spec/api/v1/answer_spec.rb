require 'rails_helper'

describe 'Answers API', type: :request do

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_file, :with_link) }

    let(:answer_response) { json['answer'] }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let(:comments_response) { answer_response['comments'] }
    let(:attachments) { answer.files }
    let(:attachments_response) { answer_response['files'] }
    let(:links) { answer.links }
    let(:links_response) { answer_response['links'] }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {get api_path, params: {access_token: access_token.token}, headers: api_headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it "returns answer's body" do
        expect(answer_response['body']).to eq(answer.body)
      end

      it_behaves_like 'API attachable'
      it_behaves_like 'API commentable'
      it_behaves_like 'API linkable'

    end
  end
end