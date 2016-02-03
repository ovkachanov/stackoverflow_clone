shared_examples_for "Publishable question" do
  it "publicate question in the channel" do
    expect(PrivatePub).to receive(:publish_to).with(path, anything)
    create_question
  end

  it "don't publicate question in the channel" do
    expect(PrivatePub).to_not receive(:publish_to).with(path, anything)
    create_invalid_question
  end
end
