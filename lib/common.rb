module Ploy
  module Util

    def Util.remote_name(deploy,branch,rev)
      return [
        deploy,
        branch,
        "#{deploy}_#{rev}.deb"
      ].join('/')
    end

  end
end
