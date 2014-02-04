require 'ploy/command/shell'

describe Ploy::Command::Shell do
  describe '#info' do 
    it 'will return the command string that will be executed' do
      expect(Ploy::Command::Shell.new.info).to eq('echo "default command"') #meh as well
    end
  end
  describe '#run' do
    it 'will run the shell command and return the result' do
      expect(Ploy::Command::Shell.new.run([])).to eq('default command')
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Shell.new.help).to match(/.+/) # meh
    end
  end
end
