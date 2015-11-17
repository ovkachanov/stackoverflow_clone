require 'rails_helper'

feature 'Show all Answers', '
  In order to find answer
  As user
  I want to view list of answer
' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'non-auth user view answers on the question' do
    visit question_path question
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
