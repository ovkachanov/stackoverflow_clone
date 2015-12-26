class Answer < ActiveRecord::Base
  include Attachable
  include Votable


  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true


  default_scope { order('best DESC') }


  def best
    ActiveRecord::Base.transaction do
      best_answer = question.best_answer
      if best_answer != self
        best_answer.update!(best: false) if best_answer
        update!(best: true)
      end
    end
  end
end
