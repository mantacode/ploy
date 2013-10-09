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
      object.should_receive(:write) do | options |
        f = options[:file]
        expect(f).to be_a(Pathname)
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
