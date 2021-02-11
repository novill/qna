require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should validate_presence_of :body }
  describe '#question' do
    it "return question for question's commment" do
      question = create(:question)
      comment =create(:comment, commentable: question)
      expect(comment.question).to eq(question)
    end
    it "return question for answer's commment" do
      answer = create(:answer)
      comment =create(:comment, commentable: answer)
      expect(comment.question).to eq(answer.question)
    end

    it "should touch the parent object" do
      commentable =  create(:question)
      commentable.should_receive(:touch)
      sleep(0.0001)
      create(:comment, commentable: commentable )
    end
  end
end