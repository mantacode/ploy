require './lib/publisher'

describe Ploy::Publisher do
  it "runs a prep command before publishing" do
    Ploy::Publisher.should_receive("system").with("lineman build")
    Ploy::Publisher.publish("spec/resources/ploy-publish.yml")
  end
end

