require 'rails_helper'

feature 'Sign up', %q{
Guest wants to register
to ask questions
 } do

given(:user) { create(:user) }

  scenario 'Unregistered user tries to sign up' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test123@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'registered user try register' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end
