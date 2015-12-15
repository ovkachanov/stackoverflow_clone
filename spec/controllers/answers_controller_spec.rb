require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:foreign_answer) { create(:answer, question: question) }

  describe 'GET #new' do
    sing_in_user
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sing_in_user
    context 'with valid attributes' do

      it 'save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sing_in_user
    context 'owner' do

      it 'assings the requested answer to @answer' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, question_id: question, id: answer, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end
    end

    context 'foreign answer' do
      it 'not change foreign answer' do
        patch :update, id: foreign_answer, question_id: question, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    sing_in_user
    context 'Authenticated user' do

      it 'delete his answer' do
        expect { delete :destroy, id: answer, question_id: question, user: @user, format: :js }.to change(@user.answers, :count).by(-1)
      end

      it 'do not delete not alias answer' do
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete any answer' do
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
    end
  end

    describe 'PATCH #best' do
      sing_in_user
      context 'answer owner' do

        it 'assings the requested answer to @answer' do
          patch :best, id: answer, question_id: question.id, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'render best template' do
          patch :best, id: answer, format: :js
          expect(response).to render_template :best
        end

        it 'set best value to true' do
          answer.reload
          expect(answer.best).to eq true
        end
      end
    end
  end
end

