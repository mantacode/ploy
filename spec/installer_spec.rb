require 'ploy/installer'

describe Ploy::Installer do
  describe "#installer" do
    it "downloads and dpkg installs a file from s3" do
      # mocking s3 is annoying

      from = "some-project/master/some-project_current.deb"

      object = double("object")
      object.should_receive(:read)

      objects = double("objects")
      objects.should_receive(:[]).with(from) { object }

      bucket = double("bucket")
      bucket.stub(:objects) { objects }

      buckets = double("buckets")
      buckets.should_receive(:[]).with("bucketname") { bucket }

      s3 = double("s3")
      s3.should_receive(:buckets) { buckets }
      AWS::S3.stub(:new) { s3 }

      Ploy::Installer.should_receive("system").with(/^dpkg -i /)
      Ploy::Installer.install("bucketname", "some-project", "master", "current")
    end
  end
end
