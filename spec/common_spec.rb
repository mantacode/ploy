require 'ploy/common'

describe Ploy::Util do
  describe '#remote_name' do
    it "does the right thing with no variant" do
      expect(Ploy::Util.remote_name('one', 'two', 'three')).to eq('one/two/one_three.deb')
    end
    it "does the right thing with a variant" do
      expect(Ploy::Util.remote_name('one', 'two', 'three', "blessed")).to eq('blessed/one/two/one_three.deb')
    end
  end
end
