class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, :user_id, presence: :true

  after_create :author_subscribe

  def best_answer
    answers.where(best: true).first
  end

   scope :created_for_day, -> { where(created_at: 1.day.ago..Time.zone.now) }

private

  def author_subscribe
    subscriptions.create(user: user)
  end
end

