class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end


end
