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
      command = double("command")
      command.should_receive(:run).with(['val'])
      Ploy::Command.should_receive(:lookup).with('cmd') { command }
      @cli.run(['cmd', 'val'])
    end
    it "will run help by default" do
      command = double("command")
      command.should_receive(:run).with([])
      Ploy::Command.should_receive(:lookup).with('help') { command }
      @cli.run([])
    end
  end

end
