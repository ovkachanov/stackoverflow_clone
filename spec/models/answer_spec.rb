require 'rails_helper'

describe Answer do
  it_behaves_like 'attachable'
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should belong_to :question }
  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }
  it { should belong_to :user }
  it { should have_many :votes }
  it { should have_many :comments }

  describe "#vote_сount" do
    let (:question) {create(:question)}
    let (:answer) {create(:answer, question: question)}
    let!(:vote_up_list) {create_list(:up_vote, 7, votable: answer)}
    let!(:vote_down_list) {create_list(:down_vote, 3, votable: answer)}

    it "should show sum of answer votes" do
      expect(answer.count_votes).to eq 4
    end
  end
end
