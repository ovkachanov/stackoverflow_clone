FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    bidy nil
  end
end
