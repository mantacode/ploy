require 'ploy/command/hooks'

describe Ploy::Command::Hooks do
  describe '#path' do 
    it 'will return the path we will search for scripts we will hook' do
      expect(Ploy::Command::Hooks.new.path).to eq('/etc/ploy/events.d')
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Hooks.new.help).to match(/.+/) # meh
    end
  end
  describe '#run :argv=>[], :input=>"Hello, World"' do
    it 'will run the shell command and return the result' do
      path = Dir.getwd + '/spec/resources/events.d'
      expect(Ploy::Command::Hooks.new(path).run([],'Hello, World!')).to eq(path+"/test_a.sh\nHello, World!")
    end
  end
end
