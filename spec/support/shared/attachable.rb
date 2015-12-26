require 'rails_helper'

shared_examples_for 'attachable' do
  let(:model) { described_class }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
end
