require "rails_helper"

RSpec.describe QuestionMailer, type: :mailer do
  describe "digest" do
    let(:question) { create(:question) }
    let(:receiver)  { question.user }
    let(:answer)  { create(:answer) }
    let(:mail) { QuestionMailer.question_subscription(receiver, answer, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer for subscribed question")
      expect(mail.to).to eq([receiver.email])
      expect(mail.from).to eq(["noanswer@localhost"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
