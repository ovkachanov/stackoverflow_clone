require_relative '../acceptance_helper'

feature 'Edit question', '
  In order edit my question
  As user
  I want to edit question' do

  given!(:current_user) { create(:user) }
  given!(:user) { create(:user) }
  given!(:his_question) { create(:question, user: current_user) }
  given!(:alien_question) { create(:question) }

  scenario 'auth user see edit link his question' do
    sign_in(current_user)
    visit root_path

    expect(page).to have_content 'Edit'
  end

  scenario 'auth user not see edit link alien question' do
    sign_in(user)
    visit root_path

    expect(page).to_not have_content 'Edit'
  end

  scenario 'auth user try to edit his question' do
    sign_in(current_user)
    visit root_path
    click_on 'Edit'
    save_and_open_page

    fill_in 'Заголовок', with: 'title10test'
    fill_in 'Ваш вопрос', with: 'text text text'
    click_on 'Save'

    expect(page).to have_content 'Your question successfully update'
    expect(page).to have_content 'title10test'
    expect(page).to have_content 'text text text'
  end
end
