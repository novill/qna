shared_examples_for 'Mighty user update question' do
  context 'with valid params' do
    let(:params) {
      {
        id: question.id,
        access_token: access_token.token,
        question: {
            title: 'some_new_title',
            body: 'some_new_body'
        }
      }
    }

    before { patch "/api/v1/questions/#{question.id}", params: params, headers: api_form_headers }

    it 'returns successful status' do
      expect(response).to be_successful
    end

    it 'updates question' do
      question.reload
      expect(question.title).to eq('some_new_title')
      expect(question.body).to eq('some_new_body')
    end

    it 'returns updated question' do
      expect(json['question']['title']).to eq('some_new_title')
      expect(json['question']['body']).to eq('some_new_body')
    end
  end

  context 'with invalid params' do
    let(:params) {
      {
          id: question.id,
          access_token: access_token.token,
          question: {
              title: nil,
              body: nil
          }
      }
    }

    before { patch "/api/v1/questions/#{question.id}", params: params, headers: api_form_headers }

    it 'does not return successful status' do
      expect(response).not_to be_successful
    end

    it 'does not update question' do
      question.reload
      expect(question.title).not_to eq('some_new_title')
      expect(question.body).not_to eq('some_new_body')
    end
  end
end