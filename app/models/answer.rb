class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order('best DESC') }

  scope :without_best, -> { where(best: false) }
  scope :only_best, -> { where(best: true).first }

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
