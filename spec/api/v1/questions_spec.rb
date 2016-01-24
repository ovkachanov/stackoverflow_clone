require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(questions[0].send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }

    let!(:comments_for_question) { create_list(:comment, 2, commentable: question, user: user) }
    let!(:comments_for_answer) { create_list(:comment, 2, commentable: answer, user: user) }
    let!(:attachments_for_question) { create_list(:attachment, 2, attachable: question) }
    let!(:attachments_for_answer) { create_list(:attachment, 2, attachable: answer) }

    let(:answer) { answers.first }
    let(:comment_for_question) { comments_for_question.first }
    let(:comment_for_answer) { comments_for_answer.first }
    let(:attachment_for_question) { attachments_for_question.first }
    let(:attachment_for_answer) { attachments_for_answer.first }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(9).at_path('question')
      end

      %w(id title body user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path('question/comments')
        end

        %w(id comment_body user_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment_for_question.send(attr.to_sym).to_json).at_path("question/comments/1/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path('question/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment_for_question.file.url.to_json).at_path('question/attachments/1/url')
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path('question/answers')
        end

        %w(id body user_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end

        context 'comments' do
          it 'included in answer object' do
            expect(response.body).to have_json_size(2).at_path('question/answers/0/comments')
          end

          %w(id comment_body user_id created_at updated_at).each do |attr|
            it "contains #{attr}" do
              expect(response.body).to be_json_eql(comment_for_answer.send(attr.to_sym).to_json).at_path("question/answers/0/comments/1/#{attr}")
            end
          end
        end

        context 'attachments' do
          it 'included in answer object' do
            expect(response.body).to have_json_size(2).at_path('question/answers/0/attachments')
          end

          it 'contains url' do
            expect(response.body).to be_json_eql(attachment_for_answer.file.url.to_json).at_path('question/answers/0/attachments/1/url')
          end
        end
      end
    end
  end
  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it 'saves the new question in the database' do
          expect { post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }
            .to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it 'does not save the question in the database' do
          expect { post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
            .to_not change(Question, :count)
        end
      end
    end
  end
end
