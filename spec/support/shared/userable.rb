require 'rails_helper'

shared_examples_for 'userable' do
  let(:model) { described_class }

  it { should belong_to :user }
  it { should have_db_index(:user_id) }
end
