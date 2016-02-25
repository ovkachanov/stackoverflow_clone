require 'rails_helper'

RSpec.describe Search do
  describe '.search' do
    %w(Questions Answers Comments Users).each do |obj|
      it "Array of #{obj}" do
        expect(ThinkingSphinx).to receive(:search).with('Request', classes: [obj.singularize.classify.constantize])
        Search.query('Request', "#{obj}")
      end
    end

    it "Anything object" do
      expect(ThinkingSphinx).to receive(:search).with('Request')
      Search.query('Request', 'Anything')
    end

    it "Invalid condition" do
      result = Search.query('Request', 'Nonexistent')
      expect(result).to eql []
    end
  end
end
