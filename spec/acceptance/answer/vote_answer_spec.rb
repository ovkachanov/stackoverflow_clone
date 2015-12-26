require_relative '../acceptance_helper'

feature 'Vote answer' do


  given (:user) { create(:user) }
  given (:question) { create(:question) }
  given! (:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end


    scenario "vote up for the answer once", js: true do
      within ".answers" do
        click_on "+"
        click_on "+"
        expect(page).to have_content "1"
      end
    end

    scenario "vote down for the answer once", js: true do
      within ".answers" do
        click_on "-"
        click_on "-"
        expect(page).to have_content "-1"
      end
    end

    scenario "can choose cancel vote for the answer", js: true do
      within ".answers" do
        click_on "+"
        click_on "cancel"
        expect(page).to have_content "0"
      end
    end
  end

  describe 'Non-authenticated user' do

    scenario "can't see vote links" do
      visit question_path(question)
      expect(page).to_not have_content "Vote for this"
    end
  end
end
