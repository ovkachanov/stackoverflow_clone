require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
        it 'should find' do
        expect(ThinkingSphinx).to receive(:search).with("12345678")
        get :index, query: "12345678"
     end
  end
end
