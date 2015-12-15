module ControllerMacros
  def sing_in_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
  end
end
