describe Fastlane::Actions::PatchAction do
  let (:action) { Fastlane::Actions::PatchAction }
  describe 'applying patches' do
    it 'passes the arguments to PatternPatch' do
      params = {
        regexp: /x/,
        text: 'y',
        mode: :append,
        global: false,
        files: ["file.txt"],
        offset: 0
      }

      patch = double :patch

      expect(PatternPatch::Patch).to receive(:new).with(params) { patch }

      expect(patch).to receive(:apply).with ["file.txt"], offset: 0

      action.run params
    end

    it 'passes a :patch parameter to PatternPatch::Patch::from_yaml' do
      params = {
        patch: "patch.yml",
        files: ["file.txt"],
        offset: 0
      }

      patch = double :patch

      expect(PatternPatch::Patch).to receive(:from_yaml).with("patch.yml") { patch }

      expect(patch).to receive(:apply).with ["file.txt"], offset: 0

      action.run params
    end

    it 'reverts with :revert' do
      params = {
        regexp: /x/,
        text: 'y',
        mode: :append,
        global: false,
        files: ["file.txt"],
        offset: 0,
        revert: true
      }

      patch = double :patch

      expect(PatternPatch::Patch).to receive(:new).with(params) { patch }

      expect(patch).to receive(:revert).with ["file.txt"], offset: 0

      action.run params
    end

    it 'reports a user_error! in case of exception' do
      expect(PatternPatch::Patch).to receive(:new).and_raise(RuntimeError)
      expect(FastlaneCore::UI).to receive(:user_error!)

      action.run text: "some text", text_file: "cant_also_have_a_text_file.txt"
    end
  end

  describe 'options' do
    let (:options) { action.available_options }
    it 'has the right number of options' do
      expect(options.count).to eq 9
    end

    it 'has a :files option' do
      option = options.find { |o| o.key == :files }
      expect(option).not_to be_nil
    end

    it 'has a :regexp option' do
      option = options.find { |o| o.key == :regexp }
      expect(option).not_to be_nil
    end

    it 'has a :text option' do
      option = options.find { |o| o.key == :text }
      expect(option).not_to be_nil
    end

    it 'has a :text_file option' do
      option = options.find { |o| o.key == :text_file }
      expect(option).not_to be_nil
    end

    it 'has a :global option' do
      option = options.find { |o| o.key == :global }
      expect(option).not_to be_nil
    end

    it 'has a :offset option' do
      option = options.find { |o| o.key == :offset }
      expect(option).not_to be_nil
    end

    it 'has a :mode option' do
      option = options.find { |o| o.key == :mode }
      expect(option).not_to be_nil
    end

    it 'has a :patch option' do
      option = options.find { |o| o.key == :patch }
      expect(option).not_to be_nil
    end

    it 'has a :revert option' do
      option = options.find { |o| o.key == :revert }
      expect(option).not_to be_nil
    end
  end

  describe 'Action methods' do
    it 'has a description' do
      expect(action.description).to be_a String
      expect(action.description).not_to be_blank
    end

    it 'has authors' do
      expect(action.authors).to be_an Array
      expect(action.authors).not_to be_blank
    end

    it 'has details' do
      expect(action.details).to be_a String
      expect(action.details).not_to be_blank
    end

    it 'has example_code' do
      expect(action.example_code).to be_an Array
      expect(action.example_code).not_to be_blank
    end

    it 'is_supported?' do
      expect(action.is_supported?(:some_platform)).to be true
    end

    it 'belongs to the :project category' do
      expect(action.category).to eq :project
    end
  end
end
