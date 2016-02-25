require_relative '../sphinx_helper'

feature 'The user can search', '
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, body: 'question body', user: user) }
  given!(:answer) { create(:answer, body: 'answer body', question: question, user: user) }
  given!(:comment) { create(:comment, comment_body: 'comment body', commentable: question, user: user) }

  background do
    index
    visit root_path
  end

  scenario 'question', js: true do

    fill_in 'query', with: question.body
    select 'Questions', from: 'condition'
    click_on 'Search'

    expect(page).to have_content question.body
    expect(page).to have_content question.title
  end

  scenario 'answer', js: true do

    fill_in 'query', with: answer.body
    select 'Answers', from: 'condition'
    click_on 'Search'

    expect(page).to have_content answer.body
  end

  scenario 'comment', js: true do

    fill_in 'query', with: comment.comment_body
    select 'Comments', from: 'condition'
    click_on 'Search'

    expect(page).to have_content comment.comment_body
  end

  scenario 'user', js: true do

    fill_in 'query', with: user.email.split('@').first
    select 'Users', from: 'condition'
    click_on 'Search'

    expect(page).to have_content user.email
  end

  scenario 'anything', js: true do

    fill_in 'query', with: 'body'
    select 'Anything', from: 'condition'
    click_on 'Search'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content comment.comment_body
  end
end
