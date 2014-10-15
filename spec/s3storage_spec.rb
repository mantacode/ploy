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
      fake_path = "nothing.deb"
      upload_path = "foo/bar"

      object = double("object")
      expect(object).to receive(:write) do |f, opts2|
        expect(f).to be_a(Pathname)
        expect(opts2).to be_a(Hash)
      end

      objects = double("objects")
      expect(objects).to receive(:[]).with(upload_path).and_return(object)

      bucket = double("bucket")
      expect(bucket).to receive(:objects).and_return(objects)

      buckets = double("buckets")
      expect(buckets).to receive(:[]).with("testbucket").and_return(bucket)

      s3 = double("s3")
      expect(s3).to receive(:buckets).and_return(buckets)
      expect(AWS::S3).to receive(:new).and_return(s3)
      
      @storage.put(fake_path, upload_path)
    end
  end
  describe "#copy" do
    it "uses aws-sdk to copy a file in s3" do
      from = "a/b/c"
      to = "d/e/f"

      from_obj = double("from_obj")
      expect(from_obj).to receive(:copy_to).with(to)

      objects = double("objects")
      expect(objects).to receive(:[]).with(from).and_return(from_obj)

      bucket = double("bucket")
      expect(bucket).to receive(:objects).and_return(objects)

      buckets = double("buckets")
      expect(buckets).to receive(:[]).with("testbucket").and_return(bucket)

      s3 = double("s3")
      expect(s3).to receive(:buckets).and_return(buckets)
      expect(AWS::S3).to receive(:new).and_return(s3)
    
      @storage.copy(from, to) 
    end
  end
  describe "#read" do
  end
  describe "#get" do
    it "downloads a file using aws-sdk" do
      from = "a/b/c"
      fake_io = double("fakeio")
      expect(fake_io).to receive(:flush)

      object = double("object")
      expect(object).to receive(:read).and_return("test")
    
      objects = double("objects")
      expect(objects).to receive(:[]).with(from).and_return(object)

      bucket = double("bucket")
      expect(bucket).to receive(:objects).and_return(objects)

      buckets = double("buckets")
      expect(buckets).to receive(:[]).with("testbucket").and_return(bucket)

      s3 = double("s3")
      expect(s3).to receive(:buckets).and_return(buckets)
      expect(AWS::S3).to receive(:new).and_return(s3)

      @storage.get(from, fake_io)
    end
  end
end
