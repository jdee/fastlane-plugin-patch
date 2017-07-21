describe Fastlane::Actions::PatchAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The patch plugin is working!")

      Fastlane::Actions::PatchAction.run(nil)
    end
  end
end
