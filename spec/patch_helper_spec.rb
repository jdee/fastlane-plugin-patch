describe Fastlane::Helper::PatchHelper do
  let (:helper) { Fastlane::Helper::PatchHelper }

  describe 'files_from_params' do
    it 'returns an array of strings when an array is passed' do
      expect(helper.files_from_params(files: [:a, :b, :c])).to eq %w{a b c}
    end

    it 'splits at commas when a string is passed' do
      expect(helper.files_from_params(files: 'a,b,c')).to eq %w{a b c}
    end

    it 'returns absolute paths when absolute paths passed in an array' do
      expect(helper.files_from_params(files: %w{/a/b/c})).to eq %w{/a/b/c}
    end

    it 'returns absolute paths when absolute paths passed in a string' do
      expect(helper.files_from_params(files: '/a/b/c')).to eq %w{/a/b/c}
    end

    it 'raises for any other type' do
      expect do
        helper.files_from_params(files: true)
      end.to raise_error ArgumentError
    end
  end
end
