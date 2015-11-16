require 'rails_helper'


feature 'Answer', %q{
 The user wants to add an answer
 to the question, and see a
 list of answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User reviews answers' do
    answer

    visit question_path question
    expect(page).to have_content answer.body
  end

  scenario 'Authenticated user create the answer' do
    sign_in(user)
    visit questions_path
    click_on 'Show'
    click_on 'Add answer'
    fill_in 'Body', with: 'Test answer'
    click_on 'Create'
    expect(page).to have_content 'Your answer successfully created.'
    expect(page.status_code).to eq 200
  end
end
