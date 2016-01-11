require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_length_of(:comment_body).is_at_least(5).is_at_most(1000) }
  it { should belong_to :commentable }
  it { should belong_to :user}
end
