require 'ploy/packager'

describe Ploy::LocalPackager do
  before(:all) do
    @lpkg = Ploy::LocalPackager.new('spec/resources/ploy-publish.yml')
  end
  it "can be initialized" do
    expect(@lpkg).to be_a(Ploy::LocalPackager)
  end

  describe "#build_deb" do
    filename = ""

    it "builds a deb file" do
      path = @lpkg.build_deb
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
      File.delete(filename)
    end

  end

  describe "#remote_package" do
    it "returns a Ploy::Package to match the local package" do
      rem = @lpkg.remote_package
      expect(rem).to be_a(Ploy::Package)
    end
  end

end
