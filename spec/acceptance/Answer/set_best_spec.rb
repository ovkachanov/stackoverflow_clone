require 'rails_helper'

feature 'Set best answer', '
  As user
  I want set best to one of answer
  In order to choose best answer
' do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:his_question) { create(:question, user: author) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: his_question, user: author) }

  describe 'Auth user' do
    before do
      sign_in(author)
    end

    scenario 'sees link best answer' do
      visit question_path(his_question)

      expect(page).to have_content answer.body
      expect(page).to have_link 'Best answer'
    end

    scenario 'set best answer to his question' do
      visit question_path(his_question)

      click_on 'Best answer'

      expect(page).to have_content 'You choose best answer'
    end

    scenario 'not set best answer to alian question' do
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end

  describe 'Non auth user' do

    scenario 'set best answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end
end
