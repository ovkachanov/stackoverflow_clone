require 'rails_helper'

describe Question do
  # it_behaves_like 'attachable'
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_db_index(:user_id) }
  it { should belong_to :user }
  it { should have_many :votes }
end
