require 'ploy/command/list'

describe Ploy::Command::List do
  before :each do
    allow_any_instance_of(Ploy::S3Storage).to receive(:list).and_return(["project-name"])
    allow_any_instance_of(Ploy::Package).to receive(:remote_version).and_return('abc')
  end

  describe "#run" do
    it "writes default format to STDOUT without --json flag" do
      expect(STDOUT).to receive(:puts).with("project-name master abc abc")
      Ploy::Command::List.new.run(['-b', 'bucket', '-a'])
    end
    it "writes JSON format to STDOUT with --json flag" do
      output = "{\"project-name\":{\"name\":\"project-name\",\"sha\":\"abc\",\"branch\":\"master\",\"blessed_sha\":\"abc\"}}"
      expect(STDOUT).to receive(:puts).with(output)
      Ploy::Command::List.new.run(['-b', 'bucket', '-j', '-a'])
    end
    it "does not print up-to-date package info without --all flag" do
      expect(STDOUT).to_not receive(:puts)
      Ploy::Command::List.new.run(['-b', 'bucket'])
    end
    it "limits output to given packages with --deployment flag" do
      expect(STDOUT).to receive(:puts).with("other-name master abc abc")
      Ploy::Command::List.new.run(['-b', 'bucket', '-d', 'other-name', '-a'])
    end
  end

  describe "#generate_list" do
    let(:list){ Ploy::Command::List.new.generate_list 'bucket', ['package'], 'master', 'blessed', false, true }
    let(:json){ Ploy::Command::List.new.generate_list 'bucket', ['package'], 'master', 'blessed', true, true }
    
    context "with false json argument" do
      it "returns an array" do
        expect(list).to be_an(Array)
      end
      it "formats returned array elements correctly with false json arguement" do
        expect(list.first).to eq('package master abc abc')
      end
    end
    
    context "with true json argument" do
      it "returns an array" do
        expect(json).to be_an(Array)
      end
      it "formats returned array elements correctly" do
        expect(json.first).to eq("{\"package\":{\"name\":\"package\",\"sha\":\"abc\",\"branch\":\"master\",\"blessed_sha\":\"abc\"}}")
      end
    end

    context "with false all argument" do
      it "returns an empty array" do
        list = Ploy::Command::List.new.generate_list 'bucket', ['package'], 'master', 'blessed', false, false
        expect(list).to be_an(Array).and be_empty
      end
    end
  end

  describe "#json_package" do
    it "converts package information into a JSON hash" do
      output = "{\"package\":{\"name\":\"package\",\"sha\":\"current-sha\",\"branch\":\"branch\",\"blessed_sha\":\"blessed-sha\"}}"
      expect(Ploy::Command::List.new.json_package "package", "branch", "current-sha", "blessed-sha").to eq(output)
    end
  end
end
