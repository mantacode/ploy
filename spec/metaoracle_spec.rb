require 'ploy/metaoracle'
require 'json'

describe Ploy::MetaOracle do
  it 'can be initialized' do
    expect(Ploy::MetaOracle.new("test")).to be_a(Ploy::MetaOracle)
  end

  describe '#query' do
    it 'queries all instances in stack' do
      instance1 = double('instance1')
      instance2 = double('instance2')
      allow(instance1).to receive(:private_ip_address).and_return('1.1.1.1')
      allow(instance2).to receive(:private_ip_address).and_return('2.2.2.2')

      instances = double('instances')
      allow(instances).to receive(:each).and_yield(instance1).and_yield(instance2)

      ec2 = double('ec2')
      allow(ec2).to receive(:instances).with(filters: [{name: 'tag:Name', values: ['test-stack']}]).and_return(instances)
      allow(Aws::EC2::Resource).to receive(:new).and_return(ec2)

      oracle = Ploy::MetaOracle.new('test-stack')
      allow(oracle).to receive(:meta).with(instance1).and_return({'pkg1' => {'version' => 'v1'}})
      allow(oracle).to receive(:meta).with(instance2).and_return({'pkg2' => {'version' => 'v2'}})

      result = oracle.query
      expect(result).to eq({
        '1.1.1.1' => {'pkg1' => {'version' => 'v1'}},
        '2.2.2.2' => {'pkg2' => {'version' => 'v2'}}
      })
    end
  end

  describe '#meta' do
    it 'fetches and parses JSON from instance' do
      instance = double('instance')
      allow(instance).to receive(:private_ip_address).and_return('1.1.1.1')

      json_response = {'package1' => {'version' => 'abc123'}}.to_json
      allow(Net::HTTP).to receive(:get).and_return(json_response)

      oracle = Ploy::MetaOracle.new('test-stack')
      result = oracle.meta(instance)

      expect(result).to eq({'package1' => {'version' => 'abc123'}})
    end
  end

  describe '#oracle_uri' do
    it "returns the right url" do
      fakeinstance = double('instance')
      fakeinstance.stub(:private_ip_address) { '1.1.1.1' }

      r = Ploy::MetaOracle.new("test").oracle_uri(fakeinstance)
      expect(r).to be_a(URI)
      expect(r.to_s).to eq('http://1.1.1.1:9876/')
    end

    it "uses port 9876" do
      instance = double('instance')
      allow(instance).to receive(:private_ip_address).and_return('10.0.0.5')

      uri = Ploy::MetaOracle.new("stack").oracle_uri(instance)
      expect(uri.port).to eq(9876)
    end
  end

end
