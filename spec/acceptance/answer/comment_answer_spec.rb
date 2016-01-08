require_relative '../acceptance_helper'

  feature 'Add comment to answer' do

    given(:user) {create(:user)}
    given!(:question) {create(:question)}
    given!(:answer)   {create(:answer, question: question)}

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "User can add comment to answer", js: true do
      within ".answers" do
      click_on "Add comment"
      fill_in "Comment", with: "I'am can create comment to answer!"
      click_on 'Create'
      expect(page).to have_content "I'am can create comment to answer!"
      end
    end
  end
