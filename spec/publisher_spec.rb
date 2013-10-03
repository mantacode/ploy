require './lib/publisher'

describe Ploy::Publisher do
  before(:all) do
    @pub = Ploy::Publisher.new("spec/resources/ploy-publish.yml")
  end

  it "is initialized correctly" do
    expect(@pub).to be_a(Ploy::Publisher)
  end

  it "runs prep steps correctly" do
    @pub.should_receive("system").with("lineman build")
    @pub.prep()
  end

  describe "#package" do
    filename = ""

    it "builds a deb file" do
      path = @pub.package()
      expect(File.exists? path).to be_true
      filename = path
    end

    it "sets a version that looks right" do
      expect(`dpkg-deb -f #{filename} Version`).to match(/master\.\d+/)
    end

    it "makes a deb with a test file at the expected location" do
      expect(`dpkg-deb -c #{filename}`).to match(/ \.\/usr\/local\/someproject\/file.txt\n/)
    end

    it "makes a deb with an upstart script" do
      expect(`dpkg-deb -c #{filename}`).to match(/ \.\/etc\/init\/some-project-initfile.conf\n/)
    end

    it "makes a deb with a metadata file" do
      expect(`dpkg-deb -c #{filename}`).to match(/ \.\/etc\/ploy\/metadata.d\/some-project.yml\n/)
    end

    after(:all) do
      system("cp #{filename} test.deb") # temporary
      File.delete(filename)
    end

  end

  describe "#remote_target_name" do
    # uses git info for _this_ repo, to exercise some private methods, so
    # we can mock these elsewhere
    it "should make the right name" do
      branch = `git symbolic-ref --short -q HEAD`.chomp
      sha = `git rev-parse HEAD`.chomp
      path = "some-project/#{branch}/some-project_#{sha}.deb"
      expect(@pub.remote_target_name).to eq(path)
    end
  end

  describe "#send" do
    it "pushes the deb to the right place" do
      pending("not ready yet")
      fakepath = "nothing.deb"

      object = double("object")
      object.should_receive(:write).with(:file => fakepath)

      objects = double("objects")
      objects.should_receive(:[]).with(uploadpath) { object }

      bucket = double("bucket")
      bucket.stub(:objects) { objects }

      buckets = double("buckets")
      buckets.should_receive(:[]).with("bucketname") { bucket }

      s3 = double("s3")
      s3.should_receive(:buckets) { buckets }
      AWS::S3.stub(:new) { s3 }

    end
  end

end

