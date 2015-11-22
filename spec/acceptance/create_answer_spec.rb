require 'rails_helper'


feature 'Answer', %q{
 The user wants to add an answer
 to the question, and see a
 list of answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User reviews answers' do


    visit question_path question
    expect(page).to have_content answer.body
  end

  scenario 'Authenticated user create the answer', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Show'
    click_on 'Add answer'
    fill_in 'Ответ', with: 'Test answer'
    click_on 'Create'
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content answer.body
  end

  scenario 'Non-Authenticated user create the answer' do
    visit questions_path
    click_on 'Show'
    expect(page).to_not have_content 'Add answer'
  end
end
