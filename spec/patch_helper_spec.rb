describe Fastlane::Helper::PatchHelper do
  let (:helper) { Fastlane::Helper::PatchHelper }

  describe 'apply_patch' do
    it 'inserts text after a pattern in :append mode' do
      original = 'alpha beta gamma'
      modified = helper.apply_patch original, /beta/, ' beta and a half', false, :append, 0
      expect(modified).to eq 'alpha beta beta and a half gamma'
    end

    it 'inserts text before a pattern in :prepend mode' do
      original = 'alpha beta gamma'
      modified = helper.apply_patch original, /beta/, 'alpha and a half ', false, :prepend, 0
      expect(modified).to eq 'alpha alpha and a half beta gamma'
    end

    it 'replaces a pattern with text in :replace mode' do
      original = 'alpha beta gamma'
      modified = helper.apply_patch original, /beta/, 'two', false, :replace, 0
      expect(modified).to eq 'alpha two gamma'
    end

    it 'raises for any other mode' do
      original = 'alpha beta gamma'
      expect do
        helper.apply_patch original, /beta/, ' beta and a half', false, :add_somewhere_i_dont_know_where, 0
      end.to raise_error ArgumentError
    end
  end

  describe 'revert_patch' do
    it 'removes a patch applied in :append mode' do
      original = 'alpha beta beta and a half gamma'
      modified = helper.revert_patch original, /beta/, ' beta and a half', false, :append, 0
      expect(modified).to eq 'alpha beta gamma'
    end

    it 'reverts a patch applied in :prepend mode' do
      original = 'alpha alpha and a half beta gamma'
      modified = helper.revert_patch original, /beta/, 'alpha and a half ', false, :prepend, 0
      expect(modified).to eq 'alpha beta gamma'
    end

    it 'raises if :replace mode specified' do
      original = 'alpha two gamma'
      expect do
        helper.revert_patch original, /beta/, 'two', false, :replace, 0
      end.to raise_error ArgumentError
    end
  end
end
