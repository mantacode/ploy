require 'common'

describe Ploy::Util do
  describe '#remote_name' do
    it "does the right thing" do
      expect(Ploy::Util.remote_name('one', 'two', 'three')).to eq('one/two/one_three.deb')
    end
  end
end
