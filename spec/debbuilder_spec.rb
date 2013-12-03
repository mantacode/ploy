require 'rspec/given'
require 'ploy/localpackage/debbuilder'

shared_examples "basic deb" do
  Then { File.exists? filename }
  And  { `dpkg-deb -f #{filename} Version`.chomp == '123456.fakebranch' }
  And  { `dpkg-deb -c #{filename}` =~ / \.\/usr\/local\/someproject\/file.txt\n/ }
  And  { `dpkg-deb -c #{filename}` =~ / \.\/etc\/init\/some-project-initfile.conf\n/ }
  And  { `dpkg-deb -c #{filename}` =~ / \.\/etc\/ploy\/metadata.d\/some-project.yml\n/ }
  And  { `dpkg-deb -f #{filename} gitrev`.chomp == 'fakesha' }
  And  { `dpkg-deb -I #{filename} postinst` =~ /^#!\/bin\/bash/ }
  And  { `dpkg-deb -I #{filename} postinst` =~ /somepostinst/ }
  after(:all) do
    File.delete(filename)
  end
end

describe Ploy::LocalPackage::DebBuilder do
  context "with everything" do
    Given(:db) do
      Ploy::LocalPackage::DebBuilder.new(
        :name          => 'some-project',
        :sha           => 'fakesha',
        :branch        => 'fakebranch',
        :timestamp     => '123456',
        :upstart_files => ['spec/resources/conf/some-project-initfile'],
        :dist_dirs     => [{'dir' => 'spec/resources/dist2', 'prefix' => '/etc/dist2'}],
        :dist_dir      => 'spec/resources/dist',
        :prefix        => '/usr/local/someproject',
        :prep_cmd      => 'lineman build',
        :postinst      => 'somepostinst'
      )
    end
    context "building a deb file" do
      When(:filename) { db.build_deb }
      Then { `dpkg-deb -c #{filename}` =~ / \.\/etc\/dist2\/dist2.txt\n/ }
      it_behaves_like "basic deb"
    end
 
    context "calculating safe versions" do
      When(:result) { db.safeversion("one-two_three") }
      Then { result == 'onetwothree' }
    end
  end

  context "without dist_dir and prefix" do
    Given(:db) do
      Ploy::LocalPackage::DebBuilder.new(
        :name          => 'some-project',
        :sha           => 'fakesha',
        :branch        => 'fakebranch',
        :timestamp     => '123456',
        :upstart_files => ['spec/resources/conf/some-project-initfile'],
        :dist_dirs     => [{'dir' => 'spec/resources/dist', 'prefix' => '/usr/local/someproject'}, {'dir' => 'spec/resources/dist2', 'prefix' => '/etc/dist2'}],
        :postinst      => 'somepostinst',
        :prep_cmd      => 'lineman build'
      )
    end
 
    context "building a deb file, no top level dist_dir and prefix" do
      When(:filename) { db.build_deb }
      Then { `dpkg-deb -c #{filename}` =~ / \.\/etc\/dist2\/dist2.txt\n/ }
      it_behaves_like "basic deb"
    end
  end

  context "without dist_dirs" do
    Given(:db) do
      Ploy::LocalPackage::DebBuilder.new(
        :name          => 'some-project',
        :sha           => 'fakesha',
        :branch        => 'fakebranch',
        :timestamp     => '123456',
        :upstart_files => ['spec/resources/conf/some-project-initfile'],
        :dist_dir      => 'spec/resources/dist',
        :prefix        => '/usr/local/someproject',
        :postinst      => 'somepostinst',
        :prep_cmd      => 'lineman build'
      )
    end
 
    context "building a deb file, no dist_dirs" do
      When(:filename) { db.build_deb }
      it_behaves_like "basic deb"
    end
  end
end
