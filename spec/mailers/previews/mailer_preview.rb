# Preview all emails at http://localhost:3000/rails/mailers/mailer

class MailerPreview < ActionMailer::Preview
  def notify
    Mailer.notify(User.first, Answer.first)
  end
end
