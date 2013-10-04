require 'ploy/metasrc'

describe Ploy::MetaSrc do
  describe '#load' do
    it "loads yaml data in a directory, keyed by deployment name" do
      msrc = Ploy::MetaSrc.new("spec/resources/metadata.d")
      data = msrc.load
      expect(data['some-project']).to be_a(Hash)
      expect(data['some-project']['name']).to eq('some-project')
    end
  end
end
