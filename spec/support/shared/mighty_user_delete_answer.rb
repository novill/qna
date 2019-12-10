shared_examples_for 'Mighty user delete answer' do
  context 'with valid params' do
    let(:params) {
      {
        id: answer.id,
        access_token: access_token.token,
      }
    }

    before { delete "/api/v1/answers/#{answer.id}", params: params, headers: api_form_headers }

    it 'returns successful status' do
      expect(response).to be_successful
    end

    it 'deletes answer' do
      expect(Answer.find_by(id: answer.id)).to be_nil
    end
  end
end