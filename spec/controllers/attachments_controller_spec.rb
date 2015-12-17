require 'rails_helper'

describe AttachmentsController do

  describe "DELETE #destroy" do

    sing_in_user

    let(:user){create(:user)}
    let!(:other_user){create(:user)}
    let(:question){create(:question, user: @user)}
    let!(:file){create(:attachment, attachable: question)}


    context "Author answer or question can" do
      it "delete their attachment" do
        expect {delete :destroy, id: file, format: :js}.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: file, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "Non author" do

      it "try delete other file" do
        sign_in(other_user)

        expect {delete :destroy, id: file, format: :js}.to_not change(Attachment, :count)
      end
    end
  end
end
