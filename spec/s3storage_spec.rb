require './lib/ploy/s3storage'

describe Ploy::S3Storage do
  before(:each) do
    @bucket = double("bucket")
    @s3 = double("s3")
    allow(@s3).to receive(:bucket).with("testbucket").and_return(@bucket)
    allow(Aws::S3::Resource).to receive(:new).and_return(@s3)
    @storage = Ploy::S3Storage.new('testbucket')
  end

  it "can be initialized" do
    expect(@storage).to be_a(Ploy::S3Storage)
  end

  describe "#put" do
    it "uses aws-sdk to upload a file to s3" do
      fakepath = "nothing.deb"
      uploadpath = "foo/bar"

      # Create a fake file
      allow(File).to receive(:open).with(fakepath, 'rb').and_yield(double("file"))

      object = double("object")
      expect(object).to receive(:put).with(hash_including(metadata: {}))

      expect(@bucket).to receive(:object).with(uploadpath).and_return(object)

      @storage.put(fakepath, uploadpath)
    end
  end
  describe "#copy" do
    it "uses aws-sdk to copy a file in s3" do
      from = "a/b/c"
      to = "d/e/f"

      to_obj = double("to_obj")
      expect(to_obj).to receive(:copy_from).with(copy_source: "testbucket/a/b/c")

      expect(@bucket).to receive(:object).with(to).and_return(to_obj)

      @storage.copy(from, to)
    end
  end

  describe "#read" do
    it "reads content from S3 object" do
      from = "a/b/c.txt"
      content = "file content"

      body = double("body")
      allow(body).to receive(:read).and_return(content)

      response = double("response")
      allow(response).to receive(:body).and_return(body)

      object = double("object")
      expect(object).to receive(:get).and_return(response)

      expect(@bucket).to receive(:object).with(from).and_return(object)

      result = @storage.read(from)
      expect(result).to eq(content)
    end
  end

  describe "#metadata" do
    it "returns metadata when object exists" do
      location = "some/path.deb"
      meta = {'git_revision' => 'abc123', 'custom_field' => 'value'}

      head_response = double("head_response")
      allow(head_response).to receive(:metadata).and_return(meta)

      object = double("object")
      expect(object).to receive(:head).and_return(head_response)

      expect(@bucket).to receive(:object).with(location).and_return(object)

      result = @storage.metadata(location)
      expect(result).to eq(meta)
    end

    it "returns empty hash when object does not exist" do
      location = "nonexistent/path.deb"

      object = double("object")
      expect(object).to receive(:head).and_raise(Aws::S3::Errors::NotFound.new(nil, 'Not Found'))

      expect(@bucket).to receive(:object).with(location).and_return(object)

      result = @storage.metadata(location)
      expect(result).to eq({})
    end
  end

  describe "#get" do
    it "downloads a file using aws-sdk" do
      from = "a/b/c"
      fakeio = double("fakeio")
      expect(fakeio).to receive(:write).with("test")
      expect(fakeio).to receive(:flush)

      object = double("object")
      expect(object).to receive(:get).and_yield("test")

      expect(@bucket).to receive(:object).with(from).and_return(object)

      @storage.get(from, fakeio)
    end
  end

  describe "#list" do
    it "lists package names excluding hub, blessed, and staging" do
      obj1 = double("obj1", key: "package1/")
      obj2 = double("obj2", key: "package2/")
      obj3 = double("obj3", key: "hub/")
      obj4 = double("obj4", key: "blessed/")

      objects = double("objects")
      allow(objects).to receive(:each).and_yield(obj1).and_yield(obj2).and_yield(obj3).and_yield(obj4)

      expect(@bucket).to receive(:objects).with(delimiter: '/').and_return(objects)

      result = @storage.list
      expect(result).to eq(["package1", "package2"])
    end
  end
end
