require 'ploy/command/base'

module Ploy
  module Command
    class Install < Base
      def run(argv)
        bucket, deploy, branch, version = argv
        Ploy::Installer.install(bucket, deploy, branch, version)
        return true
      end

      def help
        return <<helptext
usage: ploy install $bucket $deploy $branch $version

Examples:
  $ ploy install deploybucket someproject master current
  $ ploy install deploybucket someproject master 6d4a094dcaad6e421f85b24c7c75153db72ab00c

Summary:

  The install command will download and install a package that matches the
  specification given on the command line. It does not check to see whether
  anything is currently installed.

helptext
      end
    end
  end
end
