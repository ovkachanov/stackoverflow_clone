class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.created_for_day
    mail to: user.email
  end
end
