require './lib/ploy/publisher'

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
      branch = ENV['TRAVIS_BRANCH'] || `git symbolic-ref --short -q HEAD`.chomp
      expect(`dpkg-deb -f #{filename} Version`).to match(/\d+\.#{branch}/)
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

    it "makes a deb with a git revision field" do
      expect(`dpkg-deb -f #{filename} gitrev`).to match(/...\n/) # not empty
    end

    after(:all) do
      system("cp #{filename} test.deb") # temporary
      #File.delete(filename)
    end

  end

  describe "#remote_target_name" do
    # uses git info for _this_ repo, to exercise some private methods, so
    # we can mock these elsewhere
    it "should make the right remote target name" do
      branch = ENV['TRAVIS_BRANCH'] || `git symbolic-ref --short -q HEAD`.chomp
      sha = `git rev-parse HEAD`.chomp
      path = "some-project/#{branch}/some-project_#{sha}.deb"
      expect(@pub.remote_target_name).to eq(path)
    end
  end

  describe "#remote_current_copy_name" do
    it "should make the right current copy name" do
      branch = ENV['TRAVIS_BRANCH'] || `git symbolic-ref --short -q HEAD`.chomp
      path = "some-project/#{branch}/some-project_current.deb"
      expect(@pub.remote_current_copy_name).to eq(path)
    end
  end

  describe "#send" do
    it "pushes the deb to the right place" do
      fakepath = "nothing.deb"
      uploadpath = @pub.remote_target_name # already tested, right?
      Ploy::S3Storage.any_instance.should_receive(:put).with(fakepath, uploadpath, an_instance_of(Hash))
      @pub.send(fakepath)
    end
  end

  describe "#make_current" do
    it "copies new deb to current" do
      from = @pub.remote_target_name
      to = @pub.remote_current_copy_name
      Ploy::S3Storage.any_instance.should_receive(:copy).with(from, to)
      @pub.make_current
    end
  end

  describe "#publish" do
    it "calls other methods correctly" do
      @pub.should_receive(:prep)
      @pub.should_receive(:package) { "testpath" }
      @pub.should_receive(:send).with("testpath")
      @pub.should_receive(:make_current)

      @pub.publish
    end
  end

end

