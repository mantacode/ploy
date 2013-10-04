require 'ploy/command/install'

describe Ploy::Command::Install do
  describe "#run" do
    it "will run Installer#install with correct arguments and return true" do
      Ploy::Installer.should_receive(:install).with('bucket', 'deploy', 'branch', 'version') { true }
      argv = ['bucket', 'deploy', 'branch', 'version']
      expect(Ploy::Command::Install.new.run(argv)).to be_true
    end
  end
end
