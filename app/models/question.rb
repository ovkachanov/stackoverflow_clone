class Question < ActiveRecord::Base
  include Attachable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :votes, as: :votable

  validates :title, :body, :user_id, presence: :true


  def best_answer
    answers.where(best: true).first
  end
end

