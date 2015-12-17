require_relative '../acceptance_helper'

feature 'Delete file from question' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:file) { create(:attachment, attachable: question) }


  scenario 'Author try to delete the file', js: true do
    sign_in(user)
    visit question_path(question)
    save_and_open_page
    within ".question" do
      expect(page).to have_content 'Delete file'

      click_on 'Delete file'

      expect(page).to_not have_content file.file.identifier
    end

    expect(page).to have_content 'Your attachment deleted'
  end

  scenario "Only author can destroy their files", js: true do
    visit root_path

    click_link "Sign out"

    sign_in(another_user)

    visit question_path

    click_on "Show"

    within ".question" do
      expect(page).to_not have_content "Delete file"
    end
  end
end


