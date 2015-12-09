require_relative '../acceptance_helper'

feature 'Delete answer', '
  In order delete my answer
  As user
  I want to destroy answer' do

  given!(:current_user) { create(:user) }

  given!(:his_question) { create(:question, user: current_user) }
  given!(:alien_question) { create(:question) }
  given!(:question) { create(:question) }

  given!(:his_answer) { create(:answer, question: his_question, user: current_user) }
  given!(:alien_answer) { create(:answer, question: alien_question) }

  scenario 'auth user delete his answer', js: true do
    sign_in(current_user)
    visit question_path(his_question)
    within '.answers' do
       click_on 'Edit'
    end
    click_on 'Delete'

    expect(page).to_not have_content his_answer.body
    expect(current_path).to eq question_path(his_question)
  end

  scenario 'auth user can not delete alien answer' do
    sign_in(current_user)
    visit question_path(alien_question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'non-auth user try to delete the answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end

