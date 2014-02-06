require 'ploy/command/hooks'

describe Ploy::Command::Hooks do
  describe '#path' do 
    it 'will return the path we will search for scripts we will hook' do
      expect(Ploy::Command::Hooks.new.paths).to eq(['/etc/ploy/events.d'])
    end
  end
  describe '#event' do 
    it 'will return the event for this hook' do
      expect(Ploy::Command::Hooks.new.event).to eq('')
    end
  end
  describe "#help" do
    it "will return a non-empty help string" do
      expect(Ploy::Command::Hooks.new.help).to match(/.+/) # meh
    end
  end
  describe '#new :path=["./spec/resources/events.d"]' do
    describe '#run :argv=>[], :input=>"Hello, World"' do
      it 'will run the shell command and return the result' do
        path = Dir.getwd + '/spec/resources/events.d'
        expect(Ploy::Command::Hooks.new([path]).run([],'Hello, World!')).to eq(path+"/test.sh\nHello, World!")
      end
    end
  end
  describe '#new :path=>["./spec/resources/events.d"], :event=>"test"' do
    describe '#run :argv=>[], :input=>"Hello, World"' do
      it 'will run the shell command and return the result' do
        path = Dir.getwd + '/spec/resources/events.d'
        expect(Ploy::Command::Hooks.new([path],'test').run([],'Hello, World!')).to eq(path+"/test/a.sh\nHello, World!")
      end
    end
  end
end
