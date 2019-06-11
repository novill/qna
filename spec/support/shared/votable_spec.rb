RSpec.shared_examples "votable" do
  let(:user) { create(:user) }

  it 'can be voted up' do
    expect{ resource.upvote(user) }.to change(resource, :rating).from(0).to(1)
  end

  it 'can be voted down' do
    expect{ resource.downvote(user) }.to change(resource, :rating).from(0).to(-1)
  end

  it 'has correct rating' do
    expect{ resource.upvote(user) }.to change(resource, :rating).from(0).to(1)
    expect{ resource.upvote(create(:user)) }.to change(resource, :rating).from(1).to(2)
    expect{ resource.vote_back(user) }.to change(resource, :rating).from(2).to(1)
    expect{ resource.downvote(user) }.to change(resource, :rating).from(1).to(0)
  end

  it 'user can take his vote back' do
    resource.upvote(user)
    expect(resource.user_voted?(user)).to eq(true)
    resource.vote_back(user)
    expect(resource.user_voted?(user)).to eq(false)
  end
end