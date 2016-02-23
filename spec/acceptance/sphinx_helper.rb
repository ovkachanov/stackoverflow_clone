require_relative 'acceptance_helper'

RSpec.configure do |config|
  config.include SphinxMacros, type: :feature

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end
end
