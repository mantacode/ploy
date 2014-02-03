require 'ploy/command/shell'

describe Ploy::Command::Shell do
  describe '#info' do 
    it 'will return the command string that will be executed' do
      expect(Ploy::Command::Shell.new.info).toBe 'echo "Needs Implemented"' #meh as well
    end
  end
  describe '#run' do
    it 'will run the shell command and return the result' do
      expect(Ploy::Command::Shell.new.run([])).toBe 'Needs Implemented'
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Shell.new.help).to match(/.+/) # meh
    end
  end
end
