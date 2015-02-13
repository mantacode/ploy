require 'ploy/package'
require 'ploy/common'

describe Ploy::Package do
  before(:all) do
    @inst = Ploy::Package.new("testbucket", "some-project", "master", "current")
  end
  it "can be instantiated" do
    expect(@inst).to be_a Ploy::Package
  end
  describe '#install' do
    it "downloads and dpkg installs a file from s3" do
      expect_any_instance_of(Ploy::S3Storage).to receive(:get)
      expect_any_instance_of(Ploy::Package).to receive(:system).with(/^dpkg -i /)
      @inst.install
    end
  end
  describe '#check_new_version' do
    it "compares the same local and remote versions" do
      expect_any_instance_of(Ploy::Package).to receive(:`).with(/dpkg-query/).and_return("abcd\n")
      expect_any_instance_of(Ploy::S3Storage).to receive(:metadata).and_return({'git_revision' => 'abcd'})
      expect(@inst.check_new_version).to be false
    end
    it "compares different local and remote versions" do
      expect_any_instance_of(Ploy::Package).to receive(:`).with(/dpkg-query/).and_return("abcd\n")
      expect_any_instance_of(Ploy::S3Storage).to receive(:metadata).and_return({'git_revision' => 'bcd'})
      expect(@inst.check_new_version).to be true
    end
  end
  describe '#location' do # testing gravity here... but it is easy
    it "gives the correct sub-bucket location" do
      expect(@inst.location).to eq(Ploy::Util.remote_name("some-project", "master", "current"))
    end
  end
  describe "#bless" do
    it "copies to a blessed location" do
      current = Ploy::Util.remote_name("some-project", "master", "current")
      blessed = Ploy::Util.remote_name("some-project", "master", "current", "blessed")
      expect_any_instance_of(Ploy::S3Storage).to receive(:copy).with(current, blessed)
      @inst.bless
    end
  end
  describe "#upload" do
    it "uploads a new file" do
      fake_path = 'foo/bar.deb'
      expect_any_instance_of(Ploy::S3Storage).to receive(:put).with(fake_path, @inst.location, kind_of(Hash))
      @inst.upload(fake_path)
    end
  end
  describe "#make_current" do
    it "copies this package version to current" do
      package = Ploy::Util.remote_name(@inst.deploy_name, @inst.branch, 'current')
      expect_any_instance_of(Ploy::S3Storage).to receive(:copy).with(@inst.location, package)
      @inst.make_current
    end
  end
  describe "Package.from_metadata" do
    it "returns a list of package objects" do
      meta = {
        'one' => {
          'name' => 'one',
          'sha' => 'abcd',
          'branch' => 'branchname'
        },
        'two' => {
          'name' => 'two',
          'sha' => 'abcd',
          'branch' => 'branchname'
        },
        'three' => {
          'name' => 'three',
          'sha' => 'abcd',
          'branch' => 'branchname'
        },
      }
      packages = Ploy::Package.from_metadata('bucketname', meta)
      expect(packages.length).to eq(3)
    end
  end
end
