require 'rails_helper'

describe 'Answers API' do
  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it_behaves_like "API Authenticable"

context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:request) do
          post "/api/v1/questions/#{question.id}/answers",answer: attributes_for(:answer),format: :json, access_token: access_token.token
        end

        it 'returns 201 status code' do
          request
          expect(response).to be_success
        end

        it 'creates new answer for user' do
          expect { request }.to change(user.answers, :count).by(1)
        end

        it 'creates new answer for question' do
          expect { request }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:request) do
          post "/api/v1/questions/#{question.id}/answers",answer: attributes_for(:invalid_answer),format: :json, access_token: access_token.token
        end

        it 'returns 422 status code' do
          request
          expect(response.status).to eq 422
        end

        it 'does not save the answer in the database' do
          expect { request }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
