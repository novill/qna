require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable' do
    let(:resource) { create(:answer) }
  end

  it "should touch the parent object" do
    question = create(:question)
    question.should_receive(:touch)
    sleep(0.0001)
    create(:answer, question: question)
  end

end
