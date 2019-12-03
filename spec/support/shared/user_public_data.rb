shared_examples_for 'User public data' do
  it 'returns all public fields' do
    %w[id email admin created_at updated_at].each do |attr|
      expect(response_user[attr]).to eq user.send(attr).as_json
    end
  end

  it 'does not return private fields' do
    %w[password encrypted_password].each do |attr|
      expect(response_user).to_not have_key(attr)
    end
  end
end