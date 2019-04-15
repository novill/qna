require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "author_of?" do
    let(:author) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'should return true if user is author for question' do
      expect(author).to be_author_of(question)
    end

    it 'should return false if user is not author for question' do
      expect(another_user).not_to be_author_of(question)
    end
  end
end
