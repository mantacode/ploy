require 'ploy/command'
require 'ploy/command/base'
require 'ploy/command/help'

describe Ploy::Command do
  describe '#lookup' do
    it "should return an instance of ::Help when asked" do
      expect(Ploy::Command.lookup('help')).to be_a(Ploy::Command::Help)
    end
  end
  describe Ploy::Command::Base do
    it "should have a run command that returns false" do
      expect(Ploy::Command::Base.new.run([])).to be_false
    end
    it "should have a help command that returns empty string" do
      expect(Ploy::Command::Base.new.help).to eq('')
    end
    describe "#argv" do
      it 'should give us an array' do
        expect(Ploy::Command::Base.new.argv).to be_a(Array)
      end
    end
    describe "#argv ['hello', 'world']" do
      it 'should set the array' do
        #expect(Ploy::Command::Base.new.argv(['hello', 'world']).argv.shift()).to be('hello') 
      end
    end
    describe "#next" do 
      it 'should give us a nil value because we do not have a next command' do
        expect(Ploy::Command::Base.new.next).to be_nil
      end
    end
    describe "#next :command" do 
      it 'should set the next command to be executed' do
        expect(Ploy::Command::Base.new.next(Ploy::Command::Base.new).next).to be_a(Ploy::Command::Base)
      end
    end
    describe '#execute :argv' do
      it 'should return the result of the run command' do
        expect(Ploy::Command::Base.new.execute([])).to be_false
      end
    end
    describe '#execute (when there is a next action)' do
      it 'should call the next method too and return that result' do
        expect(Ploy::Command::Base.new.next(Ploy::Command::Base.new).execute([])).to be_false
      end
    end
  end
end
