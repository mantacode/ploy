require 'rspec/given'
require 'ploy/packageset'

describe Ploy::PackageSet do
  before(:each) do
    # Mock AWS SDK to prevent real AWS calls
    bucket = double("bucket")
    s3 = double("s3")
    allow(s3).to receive(:bucket).and_return(bucket)
    allow(Aws::S3::Resource).to receive(:new).and_return(s3)
  end

  context "packageset with two packages, unlocked" do
    Given(:ps) do
      Ploy::PackageSet.new(
        'packages' => {
          'package-one' => {
          },
          'package-two' => {
          }
        },
        'locked' => false
      )
    end
    context "looking at packages" do
      When(:result) { ps.packages }
      Then { expect(result).to be_a(Array) }
      And  { result.length == 2 }
      And  { expect(result[0]).to be_a(Ploy::Package) }
      And  { expect(result[1]).to be_a(Ploy::Package) }
    end
    context "checking lock status" do
      When(:result) { ps.locked? }
      Then { result == false }
    end
  end
  
  context "packageset with no packages, locked" do
    Given(:ps) { Ploy::PackageSet.new('packages' => {}, 'locked' => true) }
    When(:result) { ps.locked? }
    Then { result == true }
  end
end
