require 'rails_helper'

feature 'Sing out', %q{
 Users can
 go to the site
 } do

  given(:user) { create(:user) }
  given(:invalid_user) { build(:user) }

  scenario 'signed in user can sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'unregistered user cannot sign in' do
    sign_in invalid_user
    expect(page).to have_content 'Invalid email or password.'
  end
end
