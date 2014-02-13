require './lib/ploy/cli'

describe Ploy::Cli do
  before do
    @cli = Ploy::Cli.new
  end

  it "will initialize correctly" do
    expect(@cli).to be_a(Ploy::Cli)
  end

  describe "#run" do
    it "will lookup a command and run it with arguments" do
      exe = double("command")
      exe.should_receive(:execute).with(['val'])
      nxt = double("command")
      nxt.should_receive(:next) { exe }
      Ploy::Command.should_receive(:lookup).with('cmd') { nxt }
      @cli.run(['cmd', 'val'])
    end
    it "will run help by default" do
      exe = double("command")
      exe.should_receive(:execute)
      nxt = double("command")
      nxt.should_receive(:next) { exe }
      Ploy::Command.should_receive(:lookup).with('help') { nxt }
      @cli.run([])
    end
  end

end
