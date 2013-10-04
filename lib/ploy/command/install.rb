require 'ploy/command'

module Ploy
  module Command
    class Install < Base
      def run(argv)
        bucket, deploy, branch, version = argv
        Ploy::Installer.install(bucket, deploy, branch, version)
        return true
      end
    end
  end
end
