RSpec.shared_examples "API commentable" do
  it 'returns all' do
    expect(comments_response.size).to eq(comments.size)
  end

  it 'returns bodies' do
    comments_response.each do |comment_response|
      comment = comments.select {|comment| comment.id == comment_response['id']}[0]
      expect(comment_response['body']).to eq(comment.body)
    end
  end
end