require 'rails_helper'


describe VotesController do

    let(:user)  { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer)   { create(:answer, question: question, user: user)}


  describe "POST #up" do

    context "user can vote up and rating of vote equal 1" do

      before do
        sign_in(create(:user))
      end

      it "for the question" do
        expect {post :up, question_id: question.id, id: question, votable: question, format: :json}.to change { question.votes.sum(:rating) }.by(1)
      end

      it "for the answer" do
        expect {post :up, answer_id: answer.id, id: answer, votable: answer, format: :json}.to change{ answer.votes.sum(:rating) }.by(1)
      end

      it "send OK to client from server" do
        post :up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(200)
      end
    end
  end

    context "unregistered user" do

      it "try to vote up" do
        expect {post :up, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "author can not vote up for your questions or answers" do

      before do
        sign_in(user)
      end

      it "author can not do it" do
        expect {post :up, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(403)
      end
    end


  describe "POST #down" do

    context "user can vote down and value of vote equal -1" do

      before do
        sign_in(create(:user))
      end

      it "for the question" do
        expect {post :down, question_id: question.id, id: question, votable: question, format: :json}.to change {question.votes.sum(:rating)}.by(-1)
      end

      it "for the answer" do
        expect {post :down, answer_id: answer.id, id: answer, votable: answer, format: :json}.to change {answer.votes.sum(:rating)}.by(-1)
      end

      it "send OK to client from server" do
        post :down, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context "unregistered user" do

      it "try to vote down" do
        expect {post :down, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :down, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "author can not vote down for your questions or answers" do

      before do
        sign_in(user)
      end

      it "author can not do it" do
        expect {post :down, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(403)
      end
    end
  end


  describe "POST #cancel" do

    context "user can vote cancel" do

      before do
        sign_in(create(:user))
      end

      it "for the question" do
        post :down, question_id: question.id, id: question, votable: question, format: :json
        expect {post :unvote, question_id: question.id, id: question, votable: question, format: :json}.to change {question.votes.count}.by(-1)
      end

      it "for the answer" do
        post :up, answer_id: answer.id, id: answer, votable: answer, format: :json
        expect {post :unvote, answer_id: answer.id, id: answer, votable: answer, format: :json}.to change {answer.votes.count}.by(-1)
      end

      it "send OK to client from server" do
        post :down, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context "unregistered user" do

      it "try to vote cancel" do
        post :up, answer_id: answer.id, id: answer, votable: answer, format: :json
        expect {post :unvote, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "author can not vote cancel for your questions or answers" do

      before do
        sign_in(user)
      end

      it "author can not do it" do
        post :up, answer_id: answer.id, id: answer, votable: answer, format: :json
        expect {post :unvote, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :up, answer_id: answer.id, id: answer, votable: answer, format: :json
        post :unvote, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(403)
      end
    end
  end
end
