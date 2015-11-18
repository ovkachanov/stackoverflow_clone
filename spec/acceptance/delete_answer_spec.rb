require 'rails_helper'

feature 'Delete answer', '
  In order delete my answer
  As user
  I want to destroy answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'auth user delete his answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'non auth user try to delete the answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
