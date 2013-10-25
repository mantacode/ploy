require 'rspec/given'
require 'ploy/localpackage/debbuilder'

describe Ploy::LocalPackage::DebBuilder do
  Given(:db) do
    Ploy::LocalPackage::DebBuilder.new(
      :name          => 'some-project',
      :sha           => 'fakesha',
      :branch        => 'fakebranch',
      :timestamp     => '123456',
      :upstart_files => ['spec/resources/conf/some-project-initfile'],
      :dist_dir      => 'spec/resources/dist',
      :prefix        => '/usr/local/someproject',
      :prep_cmd      => 'lineman build'
    )
  end
  context "building a deb file" do
    When(:filename) { db.build_deb }

    Then { File.exists? filename }
    And  { `dpkg-deb -f #{filename} Version`.chomp == '123456.fakebranch' }
    And  { `dpkg-deb -c #{filename}` =~ / \.\/usr\/local\/someproject\/file.txt\n/ }
    And  { `dpkg-deb -c #{filename}` =~ / \.\/etc\/init\/some-project-initfile.conf\n/ }
    And  { `dpkg-deb -c #{filename}` =~ / \.\/etc\/ploy\/metadata.d\/some-project.yml\n/ }
    And  { `dpkg-deb -f #{filename} gitrev`.chomp == 'fakesha' }

    after(:all) do
      File.delete(filename)
    end

  end
  context "calculating safe versions" do
    When(:result) { db.safeversion("one-two_three") }
    Then { result == 'onetwothree' }
  end
end
