FactoryGirl.define do

  sequence :body do |n|
    "body#{n}test"
  end

  factory :answer do
    body
    association :question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question
    user
  end
end
