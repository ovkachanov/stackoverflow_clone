require_relative '../acceptance_helper'

feature 'Answer editing', '
  In order to fix mistake
  As an author of answer
  I want to edit my answer
' do
  given!(:current_user) { create(:user) }
  given!(:user) { create(:user) }
  given!(:his_question) { create(:question, user: current_user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: his_question, user: current_user) }

  describe 'Authenticated user' do
    before do
      sign_in(current_user)
      visit question_path(his_question)
    end

    scenario 'sees link to Edit' do
      within('.answers') { expect(page).to have_link 'Edit' }
    end

    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Ответ', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'Aut & no-aut user not see link edit' do

    scenario "Authenticated user try to edit other user's answer" do
      sign_in(user)
      visit question_path(question)

      within('.answers') { expect(page).to_not have_link 'Edit' }
    end

    scenario 'Unauthenticated user try to edit answer' do
      visit question_path(question)

      within('.answers') { expect(page).to_not have_link 'Edit' }
    end
  end
end
