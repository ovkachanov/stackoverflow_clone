require_relative '../acceptance_helper'

feature 'Sign up', %q{
Guest wants to register
to ask questions
 } do

given(:user) { create(:user) }

  scenario 'Unregistered user tries to sign up' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test123@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    within 'form' do
      click_on 'Sign up'
    end

    open_email('test123@gmail.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    fill_in 'Email', with: 'test123@gmail.com'
    fill_in 'user_password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'registered user try register' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    within 'form' do
      click_on 'Sign up'
    end
    expect(page).to have_content 'has already been taken'
  end
end
