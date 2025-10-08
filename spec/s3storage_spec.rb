require './lib/ploy/s3storage'

describe Ploy::S3Storage do
  before(:all) do
    @storage = Ploy::S3Storage.new('testbucket')
  end
  it "can be initialized" do
    expect(@storage).to be_a(Ploy::S3Storage)
  end
  describe "#put" do
    it "uses aws-sdk to upload a file to s3" do
      fakepath = "nothing.deb"
      uploadpath = "foo/bar"

      object = double("object")
      object.should_receive(:write) do | f,opts2 |
        expect(f).to be_a(Pathname)
        expect(opts2).to be_a(Hash)
      end

      objects = double("objects")
      objects.should_receive(:[]).with(uploadpath) { object }

      bucket = double("bucket")
      bucket.stub(:objects) { objects }

      buckets = double("buckets")
      buckets.should_receive(:[]).with("testbucket") { bucket }

      s3 = double("s3")
      s3.should_receive(:buckets) { buckets }
      AWS::S3.stub(:new) { s3 }
      
      @storage.put(fakepath, uploadpath)
    end
  end
  describe "#copy" do
    it "uses aws-sdk to copy a file in s3" do
      from = "a/b/c"
      to = "d/e/f"

      from_obj = double("from_obj")
      from_obj.should_receive(:copy_to).with(to)

      objects = double("objects")
      objects.should_receive(:[]).with(from) { from_obj }

      bucket = double("bucket")
      bucket.stub(:objects) { objects }

      buckets = double("buckets")
      buckets.should_receive(:[]).with("testbucket") { bucket }

      s3 = double("s3")
      s3.should_receive(:buckets) { buckets }
      AWS::S3.stub(:new) { s3 }
    
      @storage.copy(from, to) 
    end
  end

  describe "#read" do
    it "reads content from S3 object" do
      from = "a/b/c.txt"
      content = "file content"

      object = double("object")
      object.should_receive(:read).and_return(content)

      objects = double("objects")
      objects.should_receive(:[]).with(from).and_return(object)

      bucket = double("bucket")
      bucket.stub(:objects).and_return(objects)

      buckets = double("buckets")
      buckets.should_receive(:[]).with("testbucket").and_return(bucket)

      s3 = double("s3")
      s3.should_receive(:buckets).and_return(buckets)
      AWS::S3.stub(:new).and_return(s3)

      result = @storage.read(from)
      expect(result).to eq(content)
    end
  end

  describe "#metadata" do
    it "returns metadata when object exists" do
      location = "some/path.deb"
      meta = {'git_revision' => 'abc123', 'custom_field' => 'value'}

      object = double("object")
      object.should_receive(:exists?).and_return(true)
      object.should_receive(:metadata).and_return(meta)

      objects = double("objects")
      objects.should_receive(:[]).with(location).and_return(object)

      bucket = double("bucket")
      bucket.stub(:objects).and_return(objects)

      buckets = double("buckets")
      buckets.should_receive(:[]).with("testbucket").and_return(bucket)

      s3 = double("s3")
      s3.should_receive(:buckets).and_return(buckets)
      AWS::S3.stub(:new).and_return(s3)

      result = @storage.metadata(location)
      expect(result).to eq(meta)
    end

    it "returns empty hash when object does not exist" do
      location = "nonexistent/path.deb"

      object = double("object")
      object.should_receive(:exists?).and_return(false)

      objects = double("objects")
      objects.should_receive(:[]).with(location).and_return(object)

      bucket = double("bucket")
      bucket.stub(:objects).and_return(objects)

      buckets = double("buckets")
      buckets.should_receive(:[]).with("testbucket").and_return(bucket)

      s3 = double("s3")
      s3.should_receive(:buckets).and_return(buckets)
      AWS::S3.stub(:new).and_return(s3)

      result = @storage.metadata(location)
      expect(result).to eq({})
    end
  end

  describe "#get" do
    it "downloads a file using aws-sdk" do
      from = "a/b/c"
      fakeio = double("fakeio")
      fakeio.should_receive(:flush)

      object = double("object")
      object.should_receive(:read) { "test" }
    
      objects = double("objects")
      objects.should_receive(:[]).with(from) { object }

      bucket = double("bucket")
      bucket.stub(:objects) { objects }

      buckets = double("buckets")
      buckets.should_receive(:[]).with("testbucket") { bucket }

      s3 = double("s3")
      s3.should_receive(:buckets) { buckets }
      AWS::S3.stub(:new) { s3 }

      @storage.get(from, fakeio)
    end
  end
end
