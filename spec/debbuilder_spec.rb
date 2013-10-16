require 'ploy/localpackage/debbuilder'

describe Ploy::LocalPackage::DebBuilder do
  before(:all) do
    @db = Ploy::LocalPackage::DebBuilder.new(
      :name          => 'some-project',
      :sha           => 'fakesha',
      :branch        => 'fakebranch',
      :timestamp     => '123456',
      :upstart_files => ['spec/resources/conf/some-project-initfile'],
      :dist_dir      => 'spec/resources/dist',
      :prefix        => '/usr/local/someproject',
      :prep_cmd      => 'lineman build'
    );

  end
  it "can be initialized" do
    expect(@db).to be_a(Ploy::LocalPackage::DebBuilder)
  end

  describe "#build_deb" do
    filename = ""

    it "builds a deb file" do
      path = @db.build_deb
      expect(File.exists? path).to be_true
      filename = path
    end

    it "sets a version that looks right" do
      expect(`dpkg-deb -f #{filename} Version`.chomp).to eq '123456.fakebranch'
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
      expect(`dpkg-deb -f #{filename} gitrev`.chomp).to eq('fakesha')
    end

    after(:all) do
      File.delete(filename)
    end

  end

end
