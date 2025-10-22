require 'rspec/given'
require 'ploy/command/bless'

describe Ploy::Command::Bless do
  Given(:cmd) { Ploy::Command::Bless.new }
  Given(:mock_package) { double('package') }
  Given(:mock_blessed) { double('blessed_package') }

  context "blessing by deployment/branch/version" do
    Given do
      allow(Ploy::Package).to receive(:new).with('test-bucket', 'test-deploy', 'master', 'abc123').and_return(mock_package)
      allow(mock_package).to receive(:bless).with('blessed').and_return(mock_blessed)
      allow(mock_package).to receive(:deploy_name).and_return('test-deploy')
      allow(mock_package).to receive(:branch).and_return('master')
      allow(mock_package).to receive(:version).and_return('abc123')
      allow(mock_blessed).to receive(:make_current)
    end

    When(:result) { cmd.run(['-b', 'test-bucket', '-d', 'test-deploy', '-B', 'master', '-v', 'abc123']) }

    Then { result.nil? || result.is_a?(Array) }
    And { expect(mock_package).to have_received(:bless).with('blessed') }
    And { expect(mock_blessed).to have_received(:make_current) }
  end

  context "blessing with custom variant" do
    Given do
      allow(Ploy::Package).to receive(:new).with('test-bucket', 'test-deploy', 'master', 'abc123').and_return(mock_package)
      allow(mock_package).to receive(:bless).with('staging').and_return(mock_blessed)
      allow(mock_package).to receive(:deploy_name).and_return('test-deploy')
      allow(mock_package).to receive(:branch).and_return('master')
      allow(mock_package).to receive(:version).and_return('abc123')
      allow(mock_blessed).to receive(:make_current)
    end

    When(:result) { cmd.run(['-b', 'test-bucket', '-d', 'test-deploy', '-B', 'master', '-v', 'abc123', '--variant', 'staging']) }

    Then { result.nil? || result.is_a?(Array) }
    And { expect(mock_package).to have_received(:bless).with('staging') }
  end

  context "blessing from JSON file" do
    Given(:json_file) { 'spec/resources/bless_data.json' }
    Given(:json_data) do
      {
        'package1' => {'name' => 'pkg1', 'branch' => 'master', 'sha' => 'sha1', 'variant' => nil},
        'package2' => {'name' => 'pkg2', 'branch' => 'feature', 'sha' => 'sha2', 'variant' => nil}
      }
    end
    Given(:mock_package2) { double('package2') }
    Given(:mock_blessed2) { double('blessed_package2') }

    Given do
      allow(File).to receive(:read).with(json_file).and_return(json_data.to_json)
      allow(Ploy::Package).to receive(:from_metadata).with('test-bucket', json_data).and_return([mock_package, mock_package2])
      allow(mock_package).to receive(:bless).with('blessed').and_return(mock_blessed)
      allow(mock_package).to receive(:deploy_name).and_return('pkg1')
      allow(mock_package).to receive(:branch).and_return('master')
      allow(mock_package).to receive(:version).and_return('sha1')
      allow(mock_blessed).to receive(:make_current)
      allow(mock_package2).to receive(:bless).with('blessed').and_return(mock_blessed2)
      allow(mock_package2).to receive(:deploy_name).and_return('pkg2')
      allow(mock_package2).to receive(:branch).and_return('feature')
      allow(mock_package2).to receive(:version).and_return('sha2')
      allow(mock_blessed2).to receive(:make_current)
    end

    When(:result) { cmd.run(['-b', 'test-bucket', '-f', json_file]) }

    Then { result.nil? || result.is_a?(Array) }
    And { expect(mock_package).to have_received(:bless).with('blessed') }
    And { expect(mock_package2).to have_received(:bless).with('blessed') }
    And { expect(mock_blessed).to have_received(:make_current) }
    And { expect(mock_blessed2).to have_received(:make_current) }
  end
end
