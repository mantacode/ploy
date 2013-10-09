require 'ploy/installer'

describe Ploy::Installer do
  it "can be instantiated" do
    inst = Ploy::Installer.new("testbucket", "some-project", "master", "current")
    expect(inst).to be_a Ploy::Installer
  end
  before(:all) do
    @inst = Ploy::Installer.new("testbucket", "some-project", "master", "current")
  end
  describe '#install' do
    it "downloads and dpkg installs a file from s3" do
      Ploy::S3Storage.any_instance.should_receive(:get)
      Ploy::Installer.any_instance.should_receive(:system).with(/^dpkg -i /)
      @inst.install
    end
  end
  describe '#check_new_version' do
    it "compares the same local and remote versions" do
      Ploy::Installer.any_instance.should_receive(:`).with(/dpkg-query/) { "abcd\n" }
      Ploy::S3Storage.any_instance.should_receive(:metadata) { { 'git_revision' => 'abcd' } }
      expect(@inst.check_new_version).to be_false
    end
    it "compares different local and remote versions" do
      Ploy::Installer.any_instance.should_receive(:`).with(/dpkg-query/) { "abcd\n" }
      Ploy::S3Storage.any_instance.should_receive(:metadata) { { 'git_revision' => 'bcd' } }
      expect(@inst.check_new_version).to be_true
    end

  end
end
