require_relative '../acceptance_helper'

feature 'View all questions', %q{
  The user can view a list
  of all the questions
} do

 given!(:questions) { create_list(:question,2) }

  scenario 'Any User view questions' do
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }
  end
end


