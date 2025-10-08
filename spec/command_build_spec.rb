require 'rspec/given'
require 'ploy/command/build'

describe Ploy::Command::Build do
  Given(:cmd) { Ploy::Command::Build.new }
  Given(:mock_config) { double('config') }
  Given(:mock_builder) { double('builder') }

  context "building with default config file" do
    Given do
      allow(Ploy::LocalPackage::Config).to receive(:load).with('.ploy-publisher.yml').and_return([mock_config])
      allow(mock_config).to receive(:builder).and_return(mock_builder)
      allow(mock_builder).to receive(:build_deb).and_return('/tmp/package.deb')
    end

    When(:result) { cmd.run([]) }

    Then { result == true }
    And { expect(Ploy::LocalPackage::Config).to have_received(:load).with('.ploy-publisher.yml') }
    And { expect(mock_builder).to have_received(:build_deb) }
  end

  context "building with custom config file" do
    Given do
      allow(Ploy::LocalPackage::Config).to receive(:load).with('custom.yml').and_return([mock_config])
      allow(mock_config).to receive(:builder).and_return(mock_builder)
      allow(mock_builder).to receive(:build_deb).and_return('/tmp/package.deb')
    end

    When(:result) { cmd.run(['custom.yml']) }

    Then { result == true }
    And { expect(Ploy::LocalPackage::Config).to have_received(:load).with('custom.yml') }
  end

  context "building multiple packages" do
    Given(:mock_config2) { double('config2') }
    Given(:mock_builder2) { double('builder2') }

    Given do
      allow(Ploy::LocalPackage::Config).to receive(:load).with('.ploy-publisher.yml').and_return([mock_config, mock_config2])
      allow(mock_config).to receive(:builder).and_return(mock_builder)
      allow(mock_builder).to receive(:build_deb).and_return('/tmp/package1.deb')
      allow(mock_config2).to receive(:builder).and_return(mock_builder2)
      allow(mock_builder2).to receive(:build_deb).and_return('/tmp/package2.deb')
    end

    When(:result) { cmd.run([]) }

    Then { result == true }
    And { expect(mock_builder).to have_received(:build_deb) }
    And { expect(mock_builder2).to have_received(:build_deb) }
  end
end
