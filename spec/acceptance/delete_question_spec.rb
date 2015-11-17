require 'rails_helper'

feature 'Delete question', '
  In order delete my question
  As user
  I want to destroy question
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }


  scenario 'auth user try to delete his question' do
    sign_in(user)
    visit root_path
    click_on 'Delete question'

    expect(page).to have_content 'Your question deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'non auth user try to delete the question' do
    visit root_path

    expect(page).to_not have_content 'Delete question'
  end
end
