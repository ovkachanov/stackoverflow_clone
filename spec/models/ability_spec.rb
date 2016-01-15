require 'rails_helper'

describe Ability do

    subject(:ability) { Ability.new(user) }

  describe "Guest" do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe "User" do
    let!(:user) { create(:user) }
    let!(:another)  { create(:user) }
    let!(:question) { create(:question, user: user) }

    it { should be_able_to :read, :all }


    context "question" do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: another), user: user }

      it { should be_able_to :destroy, create(:question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:question, user: another), user: user }
    end


    context "answer" do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, question: question, user: another), user: user }

      it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: another), user: user }
    end

    context "comment" do
      it { should be_able_to :create, Comment }
    end


    context "Best answer" do
      let(:answer) { create(:answer, user: user) }
      let(:other_question) { create(:question, user: another) }

      it { should be_able_to :best, create(:answer, question: question), user: user }
      it { should_not be_able_to :best, create(:answer, question: other_question), user: user }
    end


    context "Attachment" do
      let(:attachment) { create(:attachment, attachable: question) }

      let(:question_two) { create(:question, user: another) }
      let(:attach) { create(:attachment, attachable: question_two) }

      it { should be_able_to :manage, attachment,user: user  }
      it { should_not be_able_to :manage, attach, user: user }
    end

    context "Vote" do
      it { should be_able_to :unvote, Vote }
      it { should be_able_to :up, Vote }
      it { should be_able_to :down, Vote }
    end
 end
end
