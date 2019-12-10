shared_examples_for 'Mighty user delete question' do
  context 'with valid params' do
    let(:params) {
      {
        id: question.id,
        access_token: access_token.token,
      }
    }

    before { delete "/api/v1/questions/#{question.id}", params: params, headers: api_form_headers }

    it 'returns successful status' do
      expect(response).to be_successful
    end

    it 'deletes question' do
      expect(Question.find_by(id: question.id)).to be_nil
    end
  end
end