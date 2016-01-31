require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:foreign_question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    sing_in_user
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
    expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sing_in_user
    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    sing_in_user

    let(:path) { '/questions' }
    let(:create_question) { post :create, question: attributes_for(:question) }
    let(:create_invalid_question) { post :create, question: attributes_for(:invalid_question) }

    it_behaves_like "Publishable question"

    context 'create question with valid attributes can only authorised user' do

      it 'create question and save in database' do
        expect { create_question }.to change(Question, :count).by(1)
      end

      it 'redirect to a new question' do
        create_question
        expect(response).to redirect_to question_path(assigns(:question))
      end


      it  'compare users_id with new question users_id' do
      create_question
        expect(assigns(question.user.id)).to eq @user_id
      end
    end

    context 'create question with invalid attributes' do
      it 'does not save save the question' do
        expect { create_invalid_question }.to_not change(Question, :count)
      end

      it 'render new template with invalid attributes' do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sing_in_user
    context 'with valid attributes' do

      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes the question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updated question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'foreign_question' do
      it 'not change foreign answer' do
        patch :update, id: foreign_question, question_id: question, answer: { body: 'updated' }, format: :js
        question.reload
        expect(question.body).to_not eq 'updated'
      end
    end
  end

  describe 'DELETE #destroy' do
    sing_in_user
    context 'User delete his question' do
      let!(:question) { create(:question, user: @user) }

      it 'delete the question' do
        expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context "User can not delete alian question" do

      it 'does not delete the question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
    end
  end
end
