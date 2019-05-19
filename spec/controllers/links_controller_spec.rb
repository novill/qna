require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  context 'question' do
    let(:question) { create(:question, user: user) }
    let!(:link) { create(:link, linkable: question) }
    it 'deletes the link on his question' do
      login(user)
      expect { delete :destroy, params: { id: link } }.to change(question.links, :count).by(-1)
    end
    it "can't delete the link on other question" do
      login(create(:user))
      expect { delete :destroy, params: { id: link } }.not_to change(Question, :count)
    end
  end

  context 'answer' do
    let(:answer) { create(:answer, user: user) }
    let!(:link) { create(:link, linkable: answer) }
    it 'deletes the link on his question' do
      login(user)
      expect { delete :destroy, params: { id: link } }.to change(answer.links, :count).by(-1)
    end
    it "can't delete the link on other question" do
      login(create(:user))
      expect { delete :destroy, params: { id: link } }.not_to change(Answer, :count)
    end
  end
end
