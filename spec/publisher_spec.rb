require './lib/ploy/publisher'

describe Ploy::Publisher do
  before(:all) do
    @pub = Ploy::Publisher.new("spec/resources/ploy-publish.yml")
  end

  it "is initialized correctly" do
    expect(@pub).to be_a(Ploy::Publisher)
  end

end

