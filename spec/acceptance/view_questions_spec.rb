require 'rails_helper'

feature 'View all questions', %q{
  The user can view a list
  of all the questions
} do

 given!(:questions) { create_list(:question,2) }

  scenario 'Any User view questions' do
    visit questions_path
    expect(page).to have_content 'MyString'
  end
end

