require 'rails_helper'

describe Vote do
  it { should belong_to :votable}
end
