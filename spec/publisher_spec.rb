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

end

