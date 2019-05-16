require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }

  it { should allow_value("http://").for(:url) }
  it { should allow_value("https://").for(:url) }
  it { should_not allow_value("foo").for(:url) }
end
