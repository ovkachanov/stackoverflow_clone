require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks answer', js: true do
    save_and_open_page
    fill_in 'Форма для ответа', with: 'text body answer'
    click_on 'Выберите файл'
    all('input[type="file"]')[0].set("#{Rails.root}/spec/spec_helper.rb")
    click_on 'Выберите файл'
    all('input[type="file"]')[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
