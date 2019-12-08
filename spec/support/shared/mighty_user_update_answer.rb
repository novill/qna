shared_examples_for 'Mighty user update answer' do
  context 'with valid params' do
    let(:params) {
      {
        id: answer.id,
        access_token: access_token.token,
        answer: {
            body: 'some_new_body'
        }
      }
    }

    before { patch "/api/v1/answers/#{answer.id}", params: params, headers: api_form_headers }

    it 'returns successful status' do
      expect(response).to be_successful
    end

    it 'updates answer' do
      answer.reload
      expect(answer.body).to eq('some_new_body')
    end

    it 'returns updated answer' do
      expect(json['answer']['body']).to eq('some_new_body')
    end
  end

  context 'with invalid params' do
    let(:params) {
      {
          id: answer.id,
          access_token: access_token.token,
          answer: {
              body: nil
          }
      }
    }

    before { patch "/api/v1/answers/#{answer.id}", params: params, headers: api_form_headers }

    it 'does not return successful status' do
      expect(response).not_to be_successful
    end

    it 'does not update answer' do
      answer.reload
      expect(answer.body).not_to eq('some_new_body')
    end
  end
end