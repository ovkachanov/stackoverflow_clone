require 'rails_helper'

describe Question do
  it_behaves_like 'attachable'
  it_behaves_like 'userable'
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe "#vote_сount" do
    let (:question) {create(:question)}
    let!(:vote_up_list) {create_list(:up_vote, 10, votable: question)}
    let!(:vote_down_list) {create_list(:down_vote, 3, votable: question)}

    it "should show sum of question votes" do
      expect(question.count_votes).to eq 7
    end
  end

  describe '#author_subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'subscribes author after create question' do
      expect(question.subscriptions.count).to eq 1
    end
  end
end
