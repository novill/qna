RSpec.shared_examples "voted" do
  let(:user) { create(:user) }
  context 'authenticated user can' do
    before { sign_in(user) }

    context 'upvote resource' do
      it 'change rating' do
        expect{ patch :upvote, params: { id: resource } }.to change(resource, :rating).from(0).to(1)
      end

      it 'render json with id, rating, current_user_voted' do
        patch :upvote, params: { id: resource }
        expect(JSON.parse(response.body)).to eq( {"id" => resource.id, "rating" => 1, "current_user_voted" => true} )
      end
    end

    context 'downvote resource' do
      it 'change rating' do
        expect{ patch :downvote, params: { id: resource } }.to change(resource, :rating).from(0).to(-1)
      end

      it 'render json with id, rating, current_user_voted' do
        patch :downvote, params: { id: resource }
        expect(JSON.parse(response.body)).to eq( {"id" => resource.id, "rating" => -1, "current_user_voted" => true} )
      end
    end

    context 'take his vote back' do
      it 'remove user from voted users' do
        patch :upvote, params: { id: resource }
        expect{ patch :vote_back, params: { id: resource } }.to change{ resource.user_voted?(user) }.from(true).to(false)
      end

      it 'render json with id, rating, current_user_voted' do
        resource.upvote(user)
        patch :vote_back, params: { id: resource }
        expect(JSON.parse(response.body)).to eq( {"id" => resource.id, "rating" => 0, "current_user_voted" => false} )
      end
    end
  end

  context "author can't vote for his resource" do
    before { sign_in(resource.user) }

    it "upvoting doesn't change rating" do
      expect{ patch :upvote, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "downvoting doesn't change rating" do
      expect{ patch :downvote, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "voting back doesn't change votes" do
      expect{ patch :vote_back, params: { id: resource } }.not_to change(Vote, :count)
    end
  end

  context "guest can't vote for resource" do

    it "upvoting doesn't change rating" do
      expect{ patch :upvote, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "downvoting doesn't change rating" do
      expect{ patch :downvote, params: { id: resource } }.not_to change(resource, :rating)
    end

    it "voting back doesn't change votes" do
      expect{ patch :vote_back, params: { id: resource } }.not_to change(Vote, :count)
    end
  end
end