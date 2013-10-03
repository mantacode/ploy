require './lib/cli'

describe Ploy::Cli do
  before do
    @cli = Ploy::Cli.new
  end

  it "will initialize correctly" do
    expect(@cli).to be_a(Ploy::Cli)
  end

  describe "#run" do
    it "will run Ploy::Publisher#publish when invoked with 'publish' as first argument" do
      pub = double("publisher")
      pub.should_receive(:publish) { true }
      Ploy::Publisher.should_receive(:new) { pub }
      @cli.run(["publish"])
    end

    it "will run Publisher#publish with an argument if one is passed in argv" do
      pub = double("publisher")
      pub.should_receive(:publish) { true }
      Ploy::Publisher.should_receive(:new).with("foo.yml") { pub }
      @cli.run(["publish","foo.yml"])
    end
  end

end
