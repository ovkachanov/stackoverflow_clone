class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, :user_id, presence: :true

  def best_answer
    answers.where(best: true).first
  end
end

