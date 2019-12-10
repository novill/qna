require 'rails_helper'

describe 'Answers API', type: :request do

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create( :question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answers_response) { json['answers'] }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      before {get api_path, params: {access_token: access_token.token}, headers: api_headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it "returns all question's answers" do
        expect(answers_response.size).to eq(answers.size)
      end

      it 'returns body for all answers' do
        answers_response.each do |answer_response|
          answer = answers.select {|answer| answer.id == answer_response['id']}[0]
          expect(answer_response['body']).to eq(answer.body)
        end
      end
    end
  end
end