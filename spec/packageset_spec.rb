require 'rspec/given'
require 'ploy/packageset'

describe Ploy::PackageSet do
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
