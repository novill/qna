require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let(:question) { create(:question, title: 'MyString') }

  describe 'GET #show' do
    before {  }

    it 'renders show view' do
      get :show, params: { query: 'some query' }
      expect(response).to render_template :show
    end
  end
end