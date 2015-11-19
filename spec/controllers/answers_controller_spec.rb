require 'rails_helper'

describe AnswersController do
  sing_in_user
  let(:current_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

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
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

  describe 'DELETE #destroy' do

    context 'Authenticated user' do

      it 'delete his answer' do
        expect { delete :destroy, question_id: question.id, id: answer, user: current_user }.to change(Answer, :count).by(-1)
      end
    end
  end

      it 'do not delete not his answer' do
        expect { delete :destroy, question_id: question.id, id: answer }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        delete :destroy, question_id: question.id, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete any answer' do
        expect { delete :destroy, question_id: question.id, id: answer }.to_not change(Answer, :count)
    end
  end
end
