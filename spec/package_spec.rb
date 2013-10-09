require 'ploy/package'
require 'ploy/common'

describe Ploy::Package do
  it "can be instantiated" do
    inst = Ploy::Package.new("testbucket", "some-project", "master", "current")
    expect(inst).to be_a Ploy::Package
  end
  before(:all) do
    @inst = Ploy::Package.new("testbucket", "some-project", "master", "current")
  end
  describe '#install' do
    it "downloads and dpkg installs a file from s3" do
      Ploy::S3Storage.any_instance.should_receive(:get)
      Ploy::Package.any_instance.should_receive(:system).with(/^dpkg -i /)
      @inst.install
    end
  end
  describe '#check_new_version' do
    it "compares the same local and remote versions" do
      Ploy::Package.any_instance.should_receive(:`).with(/dpkg-query/) { "abcd\n" }
      Ploy::S3Storage.any_instance.should_receive(:metadata) { { 'git_revision' => 'abcd' } }
      expect(@inst.check_new_version).to be_false
    end
    it "compares different local and remote versions" do
      Ploy::Package.any_instance.should_receive(:`).with(/dpkg-query/) { "abcd\n" }
      Ploy::S3Storage.any_instance.should_receive(:metadata) { { 'git_revision' => 'bcd' } }
      expect(@inst.check_new_version).to be_true
    end
  end

  describe '#location' do # testing gravity here... but it is easy
    it "gives the correct sub-bucket location" do
      expect(@inst.location).to eq(Ploy::Util.remote_name("some-project", "master", "current"))
    end
  end
  describe "#bless" do
    it "copies to a blessed location" do
      Ploy::S3Storage.any_instance.should_receive(:copy).with(
        Ploy::Util.remote_name("some-project", "master", "current"),
        Ploy::Util.remote_name("some-project", "master", "current", true)
      )
      @inst.bless
    end
  end
end
