require 'ploy/metaoracle'

describe Ploy::MetaOracle do
  it 'can be initialized' do
    expect(Ploy::MetaOracle.new("test")).to be_a(Ploy::MetaOracle)
  end

  describe '#query' do
     # no interesting tests yet
  end

  describe '#meta' do
     # no interesting tests yet
  end

  describe '#oracle_uri' do
    it "returns the right url" do
      fakeinstance = double('instance')
      fakeinstance.stub(:private_ip_address) { '1.1.1.1' }

      r = Ploy::MetaOracle.new("test").oracle_uri(fakeinstance)
      expect(r).to be_a(URI)
      expect(r.to_s).to eq('http://1.1.1.1:9876/')
    end
  end

end
