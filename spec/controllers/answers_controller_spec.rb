require 'rails_helper'

describe AnswersController do
  sing_in_user
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      let(:answer) { create(:answer, question: question, user: @user) }
      it 'delete his answer' do
        expect { delete :destroy, id: answer, question_id: question.id, user: @user }.to change(@user.answers, :count).by(-1)
      end
    end
  end

      it 'do not delete not alias answer' do
        expect { delete :destroy, id: answer, question_id: question.id }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        delete :destroy, id: answer, question_id: question.id
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete any answer' do
        expect { delete :destroy, id: answer, question_id: question.id }.to_not change(Answer, :count)
    end
  end
end
