require 'rails_helper'

describe 'Questions API', type: :request do

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      # let(:api_path) { "/api/v1/questions" } не нужен, задан выше
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:author) { question.user }
      let(:question_response) { json['questions'].first }
      let(:author_response) { json['questions'].first['user'] }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: api_headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq(questions.size)
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question[attr].to_json).to eq question.send(attr).to_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it 'returns all author public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(author_response[attr].to_json).to eq author.send(attr).to_json
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'returns none of private user fields' do
          %w[password password_confirmation].each do |attr|
            expect(answer_response[attr]).to be_nil
          end
        end

      end
    end
  end
end