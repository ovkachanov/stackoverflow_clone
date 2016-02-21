require 'rails_helper'

RSpec.describe Mailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { Mailer.notify(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notify')
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
