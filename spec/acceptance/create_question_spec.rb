require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

  given!(:current_user) { create(:user) }
  given!(:question) { create(:question, user: current_user) }

  scenario 'Authenticated user create the question' do
    sign_in(current_user)
    visit root_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Create'
    save_and_open_page

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'Non-authenticated user try to create question' do
    visit root_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
