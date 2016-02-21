require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'send mail with answer to subscribers' do
    question.subscriptions.each do |subscription|
      expect(Mailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end
    NotifySubscribersJob.perform_now(answer)
  end
end
