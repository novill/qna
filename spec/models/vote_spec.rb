require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  #it { should validate_uniqueness_of(:user).scoped_to(:votable_type, :votable_id) } не работает из-за внешнего ключа
  it 'should validate uniqueness of user in scope votable' do
    user1 = create(:user)
    question1 = create(:question)
    Vote.create user: user1, votable: question1, value: 1
    dup = Vote.create user: user1, votable: question1, value: -1
    expect(dup.errors.full_messages).to eq(["User has already been taken"])
  end
end
