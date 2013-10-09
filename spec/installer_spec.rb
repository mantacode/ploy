require 'ploy/installer'

describe Ploy::Installer do
  describe "#installer" do
    it "downloads and dpkg installs a file from s3" do
      #from = "some-project/master/some-project_current.deb"
      s3s = double("s3s")
      s3s.should_receive(:get)
      Ploy::S3Storage.should_receive(:new) { s3s }
      Ploy::Installer.should_receive("system").with(/^dpkg -i /)
      Ploy::Installer.install("bucketname", "some-project", "master", "current")
    end
  end
end
