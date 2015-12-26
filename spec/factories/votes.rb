FactoryGirl.define do

  factory :up_vote, class: "Vote" do
    rating "1"
  end

  factory :down_vote, class: "Vote" do
    rating "-1"
  end
end
