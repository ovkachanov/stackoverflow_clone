require_relative '../acceptance_helper'

feature 'Set best answer', '
  As user
  I want set best to one of answer
  In order to choose best answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given(:second_answer) { create(:answer , question: question, user: user) }


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

    scenario 'change exist best answer for own question', js: true do

      within ".answer-#{answer.id}" do
        click_on "Best answer"
        expect(page).to_not have_link "Best answer"
      end

      expect(page).to have_content 'You choose best answer'

      within ".answer-#{second_answer.id}" do
        click_on "Best answer"
        expect(page).to_not have_link "Вest answer"
      end

        expect(page).to have_content 'You choose best answer'
    end
  end

  describe 'Non auth user' do

    scenario 'not set best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end
end
