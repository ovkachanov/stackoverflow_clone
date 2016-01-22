require_relative '../acceptance_helper'

feature 'Delete question', '
  In order delete my question
  As user
  I want to destroy question' do

  given!(:current_user) { create(:user) }
  given!(:his_question) { create(:question, user: current_user) }
  given!(:alien_question) { create(:question) }


  scenario 'auth user try to delete his question', js: true do
    sign_in(current_user)
    visit question_path(his_question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content his_question.title
  end

  scenario 'auth user can not delete alien question' do
    sign_in(current_user)
    visit question_path(alien_question)

    expect(page).to_not have_content 'Delete question.'
  end

  scenario 'non auth user try to delete the question' do
    visit root_path

    expect(page).to_not have_content 'Delete question'
  end
end
