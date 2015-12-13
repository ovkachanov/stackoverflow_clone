require_relative '../acceptance_helper'

feature 'Set best answer', '
  As user
  I want set best to one of answer
  In order to choose best answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }


  describe 'Auth user' do
    before do
      sign_in(user)
    end

    scenario 'sees link best answer' do
      visit question_path(question)

      expect(page).to have_link 'Best answer'
    end

    scenario 'set best answer to his question', js: true do
      visit question_path(question)

    within '.answers' do
       click_on 'Best answer'
    end

      expect(page).to have_selector '.only_best'
      within '.only_best' do
        expect(page).to have_content answer.body
      end
      expect(page).to have_content 'You choose best answer'
    end

    scenario 'Set a different answer as the best', js: true do
      visit question_path(question)

      within '.only_best' do
        expect(page).to have_content answer.body
      end

      within '.answers' do
        expect(page).to have_content answer.body
        click_on 'Best answer'
      end

      expect(page).to have_content 'You choose best answer'
      expect(page).to have_content 'The answer is better'
    end
  end

  describe 'Non auth user' do

    scenario 'not set best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end
end



