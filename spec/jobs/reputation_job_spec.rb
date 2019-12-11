require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls Services::ReputationJob#calculate' do
    expect(Services::ReputationJob).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end

end
