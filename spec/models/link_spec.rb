require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }

  it { should allow_value("http://").for(:url) }
  it { should allow_value("https://").for(:url) }
  it { should_not allow_value("foo").for(:url) }

  context 'gist_link?' do
    it 'return false for any link' do
      expect(create(:link).gist_link?).to be_falsey
    end
    it 'return true for link to gist' do
      expect(create(:gist_link).gist_link?).to be_truthy
    end
  end

  context 'gist_content' do
    it 'return nil for any link' do
      expect(create(:link).gist_content).to be nil
    end
    it 'return content for link to gist' do
      expect(create(:gist_link).gist_content).to eq('Test gist body 1')
    end
  end


end
