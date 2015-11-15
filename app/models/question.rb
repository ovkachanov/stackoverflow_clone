class Question < ActiveRecord::Base
  validates :title, :body, presence: :true
  has_many :answers, dependent: :destroy
  belongs_to :user, class_name: 'User', foreign_key: :user_id
end
