class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable,  :omniauthable, omniauth_providers: [:facebook, :vkontakte, :twitter]

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end

  def voted?(votable)
    votes.find_by(user: self, votable: votable)
  end

  def self.find_for_oauth(auth)
  authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
  return authorization.user if authorization

    if auth.info.email
      email = auth.info.email
      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
    else
      user = User.new
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
