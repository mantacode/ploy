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
    end

    after(:all) do
      File.delete(filename)
    end

  end

end

