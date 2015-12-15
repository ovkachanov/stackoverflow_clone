require 'rails_helper'

describe Answer do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should belong_to :question }
  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }
end
