require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:questions) { create_list(:question, 3) }
    let(:receiver)  { create(:user) }
    let(:mail) { DailyDigestMailer.digest(receiver) }

    it "renders the headers" do
      expect(mail.subject).to eq("QnA question digest")
      expect(mail.to).to eq([receiver.email])
      expect(mail.from).to eq(["noanswer@localhost"])
    end

    it "renders the body" do
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
